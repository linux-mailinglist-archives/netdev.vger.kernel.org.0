Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7764717BB
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 14:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389520AbfGWMIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 08:08:21 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34406 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387777AbfGWMIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 08:08:20 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190723120817euoutp01a5b3e69ac8f52ed115db3ee65315339f~0B_-3gKWC1946319463euoutp012
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 12:08:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190723120817euoutp01a5b3e69ac8f52ed115db3ee65315339f~0B_-3gKWC1946319463euoutp012
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1563883697;
        bh=saeXoWECyoKEtOOoPI6Phu+Fdq1kw47VGG1GsjtWjEI=;
        h=From:To:Cc:Subject:Date:References:From;
        b=RZwUL4gmUIGVRyMPmFrrF7vR9Xy12Wy7k+3r29Pjf38rlj1L0ucHZ40JZW8QM1SMr
         ugp0EaxqzlmrPCGKWshqZ8yUDLjQwISLpu0qMyGOn9z6CyuHIcTZ2JFnBbtx7OHkU/
         9ynofT0OO+gnGQUz6TINqmjKaM1QAMKFK8OLxQl0=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190723120816eucas1p1136e3b1061351f354b732e7946ff4555~0B__bWh721147711477eucas1p1H;
        Tue, 23 Jul 2019 12:08:16 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id CF.6A.04377.0B8F63D5; Tue, 23
        Jul 2019 13:08:16 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190723120815eucas1p21027b1ab47daba7ebb3a885bf869be8a~0B_9xDh1f2866228662eucas1p2c;
        Tue, 23 Jul 2019 12:08:15 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190723120815eusmtrp26b6947496f450fbf458446b45efdea4a~0B_9mgU8D0548605486eusmtrp2S;
        Tue, 23 Jul 2019 12:08:15 +0000 (GMT)
X-AuditID: cbfec7f4-12dff70000001119-85-5d36f8b05c0f
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 26.DF.04146.FA8F63D5; Tue, 23
        Jul 2019 13:08:15 +0100 (BST)
Received: from imaximets.rnd.samsung.ru (unknown [106.109.129.180]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190723120814eusmtip2a569cc20adc435617bf5b5c96b33792f~0B_855vIj0299402994eusmtip2f;
        Tue, 23 Jul 2019 12:08:14 +0000 (GMT)
From:   Ilya Maximets <i.maximets@samsung.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        xdp-newbies@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ilya Maximets <i.maximets@samsung.com>
Subject: [PATCH bpf] libbpf: fix using uninitialized ioctl results
Date:   Tue, 23 Jul 2019 15:08:10 +0300
Message-Id: <20190723120810.28801-1-i.maximets@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsWy7djP87obfpjFGjyexGLx5edtdovPR46z
        WSxe+I3ZYs75FhaLK+0/2S0u75rDZrHi0Al2i2MLxCy29+9jdOD02LLyJpPH4j0vmTy6blxi
        9ti0qpPNo2/LKkaPz5vkAtiiuGxSUnMyy1KL9O0SuDKad3YzFlwVrnj66hxLA2OzQBcjJ4eE
        gInEtunX2LoYuTiEBFYwSlw82QPlfGGUmPRmDTOE85lRYs30k+wwLb2/F7JCJJYzSiz5eYoJ
        wvnBKLF541xWkCo2AR2JU6uPMILYIgJSEh93bGcHKWIWWMok8X7hFqAlHBzCAk4SH3bwg9Sw
        CKhK9C5sYAGxeQWsJVb/u8cCsU1eYvWGA2BnSAi8ZpPYvvYeI0TCRWLK3IVMELawxKvjW6DO
        k5H4v3M+VLxe4n7LS0aI5g5GiemH/kEl7CW2vD7HDnIEs4CmxPpd+iCmhICjRFOLN4TJJ3Hj
        rSBIMTOQOWnbdGaIMK9ER5sQxAwVid8HlzND2FISN999hjrAQ2I71B4hgViJjc/+s09glJuF
        sGoBI+MqRvHU0uLc9NRio7zUcr3ixNzi0rx0veT83E2MwDRx+t/xLzsYd/1JOsQowMGoxMO7
        YY9prBBrYllxZe4hRgkOZiUR3sAGs1gh3pTEyqrUovz4otKc1OJDjNIcLErivNUMD6KFBNIT
        S1KzU1MLUotgskwcnFINjI5FvZ5HJ3B5XMuw+xC2YI/MxsDG6Sdl69eZL7C8+uFlmek+lTfX
        vl/8Ka76qvvH4cb+6bM0pW2ycsNk53dvffqp7kaF6VGZ631TBH9kPy2e9D/7WVvbfXXWg6b1
        pnp7muVnzFu3Mymod66XuOJPwUM7Pl3l/n1x+dV7Pm6OiXX9/dc52R45JimxFGckGmoxFxUn
        AgB5shHCDwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t/xe7rrf5jFGpyZL27x5edtdovPR46z
        WSxe+I3ZYs75FhaLK+0/2S0u75rDZrHi0Al2i2MLxCy29+9jdOD02LLyJpPH4j0vmTy6blxi
        9ti0qpPNo2/LKkaPz5vkAtii9GyK8ktLUhUy8otLbJWiDS2M9AwtLfSMTCz1DI3NY62MTJX0
        7WxSUnMyy1KL9O0S9DKad3YzFlwVrnj66hxLA2OzQBcjJ4eEgIlE7++FrF2MXBxCAksZJc7t
        288MkZCS+PHrAiuELSzx51oXG0TRN0aJj7PesoMk2AR0JE6tPsIIYosANXzcsZ0dpIhZYDWT
        xPyZT4AcDg5hASeJDzv4QWpYBFQlehc2sIDYvALWEqv/3WOBWCAvsXrDAeYJjDwLGBlWMYqk
        lhbnpucWG+oVJ+YWl+al6yXn525iBAbotmM/N+9gvLQx+BCjAAejEg/vhj2msUKsiWXFlbmH
        GCU4mJVEeAMbzGKFeFMSK6tSi/Lji0pzUosPMZoCLZ/ILCWanA+MnrySeENTQ3MLS0NzY3Nj
        Mwslcd4OgYMxQgLpiSWp2ampBalFMH1MHJxSDYychz5ONriU8qFjjseXPV6zdVoyr8doGoed
        bC6Y8mq/SvjX7BtRclc8DoY+0TVY8fbxw0smbGb5YdeOrxJrnmPF0qO7uPRDxsU1b1oK7FYp
        F35WMWw7ETRLXVXK0C5Wim3z9K4Lievr9aV6LCeUcHcsyr6SyXOI16XjyccMjQjN8EKtP45l
        v5RYijMSDbWYi4oTAQJ9VKxmAgAA
X-CMS-MailID: 20190723120815eucas1p21027b1ab47daba7ebb3a885bf869be8a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190723120815eucas1p21027b1ab47daba7ebb3a885bf869be8a
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190723120815eucas1p21027b1ab47daba7ebb3a885bf869be8a
References: <CGME20190723120815eucas1p21027b1ab47daba7ebb3a885bf869be8a@eucas1p2.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'channels.max_combined' initialized only on ioctl success and
errno is only valid on ioctl failure.

The code doesn't produce any runtime issues, but makes memory
sanitizers angry:

 Conditional jump or move depends on uninitialised value(s)
    at 0x55C056F: xsk_get_max_queues (xsk.c:336)
    by 0x55C05B2: xsk_create_bpf_maps (xsk.c:354)
    by 0x55C089F: xsk_setup_xdp_prog (xsk.c:447)
    by 0x55C0E57: xsk_socket__create (xsk.c:601)
  Uninitialised value was created by a stack allocation
    at 0x55C04CD: xsk_get_max_queues (xsk.c:318)

Additionally fixed warning on uninitialized bytes in ioctl arguments:

 Syscall param ioctl(SIOCETHTOOL) points to uninitialised byte(s)
    at 0x648D45B: ioctl (in /usr/lib64/libc-2.28.so)
    by 0x55C0546: xsk_get_max_queues (xsk.c:330)
    by 0x55C05B2: xsk_create_bpf_maps (xsk.c:354)
    by 0x55C089F: xsk_setup_xdp_prog (xsk.c:447)
    by 0x55C0E57: xsk_socket__create (xsk.c:601)
  Address 0x1ffefff378 is on thread 1's stack
  in frame #1, created by xsk_get_max_queues (xsk.c:318)
  Uninitialised value was created by a stack allocation
    at 0x55C04CD: xsk_get_max_queues (xsk.c:318)

CC: Magnus Karlsson <magnus.karlsson@intel.com>
Fixes: 1cad07884239 ("libbpf: add support for using AF_XDP sockets")
Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
---
 tools/lib/bpf/xsk.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 5007b5d4fd2c..c4f912dc30f9 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -317,7 +317,7 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
 
 static int xsk_get_max_queues(struct xsk_socket *xsk)
 {
-	struct ethtool_channels channels;
+	struct ethtool_channels channels = { .cmd = ETHTOOL_GCHANNELS };
 	struct ifreq ifr;
 	int fd, err, ret;
 
@@ -325,7 +325,7 @@ static int xsk_get_max_queues(struct xsk_socket *xsk)
 	if (fd < 0)
 		return -errno;
 
-	channels.cmd = ETHTOOL_GCHANNELS;
+	memset(&ifr, 0, sizeof(ifr));
 	ifr.ifr_data = (void *)&channels;
 	strncpy(ifr.ifr_name, xsk->ifname, IFNAMSIZ - 1);
 	ifr.ifr_name[IFNAMSIZ - 1] = '\0';
@@ -335,7 +335,7 @@ static int xsk_get_max_queues(struct xsk_socket *xsk)
 		goto out;
 	}
 
-	if (channels.max_combined == 0 || errno == EOPNOTSUPP)
+	if (err || channels.max_combined == 0)
 		/* If the device says it has no channels, then all traffic
 		 * is sent to a single stream, so max queues = 1.
 		 */
-- 
2.17.1

