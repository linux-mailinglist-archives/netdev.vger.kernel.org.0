Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D10B692BA8
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 00:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbjBJXye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 18:54:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjBJXyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 18:54:33 -0500
X-Greylist: delayed 470 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 10 Feb 2023 15:54:32 PST
Received: from mailgw.nuclearcat.com (mailgw.nuclearcat.com [78.47.178.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D73199FA
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 15:54:32 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5EB7F5F4BF
        for <netdev@vger.kernel.org>; Sat, 11 Feb 2023 01:46:38 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nuclearcat.com;
        s=dkim; t=1676072798; h=from:subject:date:message-id:to:mime-version:content-type:
         content-transfer-encoding; bh=NCn067PMRWjJgMExq/EJqhiYQbyTAAM2VIqX7Dj+Cng=;
        b=YFLR3PwjTqzpY2cZnbG/Eg+Klchn3/tVW7UWyII9nvWSJQ3yfXYoDZdg8ijZlOfdrRO9dX
        9KfreTgBJcy+0HuWll8w8RGWIXNwmrJrKkON5cyZMyaseVSC7QKEJCMQ4rzxoDBtLWrA3T
        vFWjFnLED7PtkhYf3JKMWK2lBlL62eGk55k98cjznXl87H1Oy3zQRHg/AeVhGiudRy7vO9
        7PptYg+jWInbrSDeTEgJjPIM1MPcRa3cB57p4khK+Mj2C+6pAwfnSTkzV1jmkkwLPJuBSq
        9EnU0kX8RuZmi19XZmbSkNbb0wm+zOkmYvRKKc/J6RH6HtB3V4mNFIUb/R2lgg==
Message-ID: <b90aafd60f264e4e2dd3367974f3bd16c3f17fa8.camel@nuclearcat.com>
Subject: [PATCH iproute2] libnetlink.c: Fix memory leak in batch mode
From:   Denys Fedoryshchenko <nuclearcat@nuclearcat.com>
To:     netdev@vger.kernel.org
Date:   Sat, 11 Feb 2023 01:46:37 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu1 
MIME-Version: 1.0
X-Last-TLS-Session-Version: TLSv1.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During testing we noticed significant memory leak that is easily
reproducible and detectable with valgrind:

=3D=3D2006284=3D=3D 393,216 bytes in 12 blocks are definitely lost in loss =
record 5 of 5
=3D=3D2006284=3D=3D    at 0x4848899: malloc (in /usr/libexec/valgrind/vgpre=
load_memcheck-amd64-linux.so)
=3D=3D2006284=3D=3D    by 0x18C73E: rtnl_recvmsg (libnetlink.c:830)
=3D=3D2006284=3D=3D    by 0x18CF9E: __rtnl_talk_iov (libnetlink.c:1032)
=3D=3D2006284=3D=3D    by 0x18D3CE: __rtnl_talk (libnetlink.c:1140)
=3D=3D2006284=3D=3D    by 0x18D4DE: rtnl_talk (libnetlink.c:1168)
=3D=3D2006284=3D=3D    by 0x11BF04: tc_filter_modify (tc_filter.c:224)
=3D=3D2006284=3D=3D    by 0x11DD70: do_filter (tc_filter.c:748)
=3D=3D2006284=3D=3D    by 0x116B06: do_cmd (tc.c:210)
=3D=3D2006284=3D=3D    by 0x116C7C: tc_batch_cmd (tc.c:231)
=3D=3D2006284=3D=3D    by 0x1796F2: do_batch (utils.c:1701)
=3D=3D2006284=3D=3D    by 0x116D05: batch (tc.c:246)
=3D=3D2006284=3D=3D    by 0x117327: main (tc.c:331)
=3D=3D2006284=3D=3D
=3D=3D2006284=3D=3D LEAK SUMMARY:
=3D=3D2006284=3D=3D    definitely lost: 884,736 bytes in 27 blocks

In case nlmsg_type =3D=3D NLMSG_ERROR and if answer set to NULL, we
should free(buf) too.

Signed-off-by: Denys Fedoryshchenko <denys.f@collabora.com>
---
 lib/libnetlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/libnetlink.c b/lib/libnetlink.c
index c8976043..68360b0f 100644
--- a/lib/libnetlink.c
+++ b/lib/libnetlink.c
@@ -1099,6 +1099,8 @@ next:
=20
 				if (answer)
 					*answer =3D (struct nlmsghdr *)buf;
+				else
+					free(buf);
 				return 0;
 			}
=20
--=20
2.34.1


