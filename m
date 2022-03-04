Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08A014CD64F
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 15:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239852AbiCDO2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 09:28:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239834AbiCDO15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 09:27:57 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4DE1BAF25;
        Fri,  4 Mar 2022 06:27:08 -0800 (PST)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nQ8tR-000Foa-Vf; Fri, 04 Mar 2022 15:26:54 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     torvalds@linux-foundation.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        syzbot+11421fbbff99b989670e@syzkaller.appspotmail.com,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Willy Tarreau <w@1wt.eu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH] mm: Consider __GFP_NOWARN flag for oversized kvmalloc() calls
Date:   Fri,  4 Mar 2022 15:26:32 +0100
Message-Id: <8a99a175d25f4bcce6b78cee8fa536e40b987b0a.1646403182.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26471/Fri Mar  4 10:24:47 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzkaller was recently triggering an oversized kvmalloc() warning via
xdp_umem_create().

The triggered warning was added back in 7661809d493b ("mm: don't allow
oversized kvmalloc() calls"). The rationale for the warning for huge
kvmalloc sizes was as a reaction to a security bug where the size was
more than UINT_MAX but not everything was prepared to handle unsigned
long sizes.

Anyway, the AF_XDP related call trace from this syzkaller report was:

  kvmalloc include/linux/mm.h:806 [inline]
  kvmalloc_array include/linux/mm.h:824 [inline]
  kvcalloc include/linux/mm.h:829 [inline]
  xdp_umem_pin_pages net/xdp/xdp_umem.c:102 [inline]
  xdp_umem_reg net/xdp/xdp_umem.c:219 [inline]
  xdp_umem_create+0x6a5/0xf00 net/xdp/xdp_umem.c:252
  xsk_setsockopt+0x604/0x790 net/xdp/xsk.c:1068
  __sys_setsockopt+0x1fd/0x4e0 net/socket.c:2176
  __do_sys_setsockopt net/socket.c:2187 [inline]
  __se_sys_setsockopt net/socket.c:2184 [inline]
  __x64_sys_setsockopt+0xb5/0x150 net/socket.c:2184
  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
  entry_SYSCALL_64_after_hwframe+0x44/0xae

Björn mentioned that requests for >2GB allocation can still be valid:

  The structure that is being allocated is the page-pinning accounting.
  AF_XDP has an internal limit of U32_MAX pages, which is *a lot*, but
  still fewer than what memcg allows (PAGE_COUNTER_MAX is a LONG_MAX/
  PAGE_SIZE on 64 bit systems). [...]

  I could just change from U32_MAX to INT_MAX, but as I stated earlier
  that has a hacky feeling to it. [...] From my perspective, the code
  isn't broken, with the memcg limits in consideration. [...]

Linus says:

  [...] Pretty much every time this has come up, the kernel warning has
  shown that yes, the code was broken and there really wasn't a reason
  for doing allocations that big.

  Of course, some people would be perfectly fine with the allocation
  failing, they just don't want the warning. I didn't want __GFP_NOWARN
  to shut it up originally because I wanted people to see all those
  cases, but these days I think we can just say "yeah, people can shut
  it up explicitly by saying 'go ahead and fail this allocation, don't
  warn about it'".

  So enough time has passed that by now I'd certainly be ok with [it].

Thus allow call-sites to silence such userspace triggered splats if the
allocation requests have __GFP_NOWARN. For xdp_umem_pin_pages()'s call
to kvcalloc() this is already the case, so nothing else needed there.

Fixes: 7661809d493b ("mm: don't allow oversized kvmalloc() calls")
Reported-by: syzbot+11421fbbff99b989670e@syzkaller.appspotmail.com
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: syzbot+11421fbbff99b989670e@syzkaller.appspotmail.com
Cc: Björn Töpel <bjorn@kernel.org>
Cc: Magnus Karlsson <magnus.karlsson@intel.com>
Cc: Willy Tarreau <w@1wt.eu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Link: https://lore.kernel.org/bpf/CAJ+HfNhyfsT5cS_U9EC213ducHs9k9zNxX9+abqC0kTrPbQ0gg@mail.gmail.com
Link: https://lore.kernel.org/bpf/20211201202905.b9892171e3f5b9a60f9da251@linux-foundation.org
---
 [ Hi Linus, just to follow-up on the discussion from here [0], I've cooked
   up proper and tested patch. Feel free to take it directly to your tree if
   you prefer, or we could also either route it via bpf or mm, whichever way
   is best. Thanks!
   [0] https://lore.kernel.org/bpf/CAHk-=wiRq+_jd_O1gz3J6-ANtXMY7iLpi8XFUcmtB3rBixvUXQ@mail.gmail.com/ ]

 mm/util.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/util.c b/mm/util.c
index 7e43369064c8..d3102081add0 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -587,8 +587,10 @@ void *kvmalloc_node(size_t size, gfp_t flags, int node)
 		return ret;
 
 	/* Don't even allow crazy sizes */
-	if (WARN_ON_ONCE(size > INT_MAX))
+	if (unlikely(size > INT_MAX)) {
+		WARN_ON_ONCE(!(flags & __GFP_NOWARN));
 		return NULL;
+	}
 
 	return __vmalloc_node(size, 1, flags, node,
 			__builtin_return_address(0));
-- 
2.21.0

