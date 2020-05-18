Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 794B91D794E
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 15:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgERNFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 09:05:39 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56901 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726993AbgERNFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 09:05:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589807137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=MupegCy8DSiuqkjR0FgvNckJ4CpNVOhSZCWewW5Gu+M=;
        b=NlanhVImycT2UcpAeqUqRSWU6tXMh/WvE6YTjeFKID+WO8D2w+x7nynj8zmrdneoOwy5V8
        USCcfGWUSOv3j1JUGvX9cpYtRGQeP1enxDFYNRFI17eHpgKzoPYpNpsLHBNzQT3j1yoFd3
        fqymd2561xBphoGJMVOLtzo00OKFdGA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-E2W_Bl0ZOvOATN6S5Zvo3w-1; Mon, 18 May 2020 09:05:35 -0400
X-MC-Unique: E2W_Bl0ZOvOATN6S5Zvo3w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 88408100CCC2;
        Mon, 18 May 2020 13:05:32 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.60])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E6CF62E05C;
        Mon, 18 May 2020 13:05:28 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 92BF53063F607;
        Mon, 18 May 2020 15:05:27 +0200 (CEST)
Subject: [PATCH bpf-next] bpf: fix too large copy from user in bpf_test_init
From:   Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Date:   Mon, 18 May 2020 15:05:27 +0200
Message-ID: <158980712729.256597.6115007718472928659.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit bc56c919fce7 ("bpf: Add xdp.frame_sz in bpf_prog_test_run_xdp().")
recently changed bpf_prog_test_run_xdp() to use larger frames for XDP in
order to test tail growing frames (via bpf_xdp_adjust_tail) and to have
memory backing frame better resemble drivers.

The commit contains a bug, as it tries to copy the max data size from
userspace, instead of the size provided by userspace.  This cause XDP
unit tests to fail sporadically with EFAULT, an unfortunate behavior.
The fix is to only copy the size specified by userspace.

Fixes: bc56c919fce7 ("bpf: Add xdp.frame_sz in bpf_prog_test_run_xdp().")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/bpf/test_run.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 30ba7d38941d..bfd4ccd80847 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -160,16 +160,20 @@ static void *bpf_test_init(const union bpf_attr *kattr, u32 size,
 			   u32 headroom, u32 tailroom)
 {
 	void __user *data_in = u64_to_user_ptr(kattr->test.data_in);
+	u32 user_size = kattr->test.data_size_in;
 	void *data;
 
 	if (size < ETH_HLEN || size > PAGE_SIZE - headroom - tailroom)
 		return ERR_PTR(-EINVAL);
 
+	if (user_size > size)
+		return ERR_PTR(-EMSGSIZE);
+
 	data = kzalloc(size + headroom + tailroom, GFP_USER);
 	if (!data)
 		return ERR_PTR(-ENOMEM);
 
-	if (copy_from_user(data + headroom, data_in, size)) {
+	if (copy_from_user(data + headroom, data_in, user_size)) {
 		kfree(data);
 		return ERR_PTR(-EFAULT);
 	}
@@ -486,8 +490,6 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 
 	/* XDP have extra tailroom as (most) drivers use full page */
 	max_data_sz = 4096 - headroom - tailroom;
-	if (size > max_data_sz)
-		return -EINVAL;
 
 	data = bpf_test_init(kattr, max_data_sz, headroom, tailroom);
 	if (IS_ERR(data))


