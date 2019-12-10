Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E32A11922E
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 21:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbfLJUgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 15:36:17 -0500
Received: from mout.kundenserver.de ([212.227.126.135]:47765 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbfLJUgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 15:36:16 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1M2ep5-1iiuph1YVD-004DY0; Tue, 10 Dec 2019 21:35:54 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Randy Dunlap <rdunlap@infradead.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] bpf: Fix build in minimal configurations, again
Date:   Tue, 10 Dec 2019 21:35:46 +0100
Message-Id: <20191210203553.2941035-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:/TPNkN7ip+x2EGFaeArJV7t8UOMDz3Xt3D+KTG86o+YtHi7AQpl
 EA0traGRcVUYNiVhb1WcqtyedHFK/G7uo0ODPsfSwvljgdSlfpiB9jNCLcGrp8AhFzBC3Rd
 4nUPKrnESghS/cdlCX+dbI/zA0oHna+X0b/mFXnE8c9EQLoI9fPJU9FDHyh3lXC7+LwYcnO
 MgvBxcOH6E8fFfruQkYlA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:bT0fWJOkfpk=:6CchuXFwP8SMBieEroZBrH
 AEk/STZiwVmNZ6TG+ImhFDC8ApYwPA7+2PF1wJ1oF4yezz4fciDC2lAIcsYU8l9tOdKyaAspc
 0SV4G8rpDiBjXWCLZFHS7Z0Te6aJKDsHTnwW5S830ljYf1BSx2ot7TrIb+leoxWvV/rJpv7G6
 s93O3GFciGFrMcGQvg/4y5kuZTog+nYzBYsYTkoMhg94yai9Lt1IRXZ+Hfqgwboq+fyK9dxlB
 l9BeW0HRcPSCTz/Ffv3pRWOc8grqW1Ch9/qcx8X/MvZc6NZI5Q0pkb9C1F3Luz2JswPZotGUe
 3b2aLkC6+GHufoBizFdA/b0KJSMyKqrgfbX/X/ZsxY1LNOZggZZ7D4Azve0M5vAtt9elY0gA9
 1O8BK9hMoUxBG7rBjdE86VP0HDrKI3nYXD6GFOXW1asqP8X0sPceT2JqFJ0WORXaDcISz8cMK
 Ql2klZPu/IBSMdURuGUq/MX7eul0lx+jgH4enSmzY7dZ0A1LiJ9vyGUrwdLbj9qrwmyqRc+kg
 TH7oDzkvFT7pPOAuqi3JXAyT2MEIRPqIp7Lg3RW6MlfCM+IO1BmLFprg6nq4n9FiNKMEZN+Jc
 fwQldPMpfVPv/oy+cOmzm3pR+g+W/VRoQvQtsNui5r/0YTD6VxIC3t5mfw9z41bzv60Cdm+Ur
 KrxfaMaRqcW23Ic55KNRGxmoqmwoIfzyZnL0e85ry9EBbcgd/hCYNDkuvB74++T31XmWyNWdZ
 MsT72djQzrEtDUsHBD7Tznyn0vpyOO9cMJpdu1OWpNwJfp/kDX9ISul2HBStsFU+t+lf3z5xB
 8qrhMqfuRGHL0wlzT9vDVAF2ZruLF9m1EUVzvrSuay9XrZLsyZR0d53z/apMy4yDL2M51VGDd
 0BQYnKMJ8IWxWvoy3Jfg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Building with -Werror showed another failure:

kernel/bpf/btf.c: In function 'btf_get_prog_ctx_type.isra.31':
kernel/bpf/btf.c:3508:63: error: array subscript 0 is above array bounds of 'u8[0]' {aka 'unsigned char[0]'} [-Werror=array-bounds]
  ctx_type = btf_type_member(conv_struct) + bpf_ctx_convert_map[prog_type] * 2;

I don't actually understand why the array is empty, but a similar
fix has addressed a related problem, so I suppose we can do the
same thing here.

Fixes: ce27709b8162 ("bpf: Fix build in minimal configurations")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 kernel/bpf/btf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 7d40da240891..ed2075884724 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3470,6 +3470,7 @@ static u8 bpf_ctx_convert_map[] = {
 	[_id] = __ctx_convert##_id,
 #include <linux/bpf_types.h>
 #undef BPF_PROG_TYPE
+	0, /* avoid empty array */
 };
 #undef BPF_MAP_TYPE
 
-- 
2.20.0

