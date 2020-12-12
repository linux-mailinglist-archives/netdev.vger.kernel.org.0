Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E38982D8749
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 16:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439271AbgLLPcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 10:32:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728704AbgLLPc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 10:32:29 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0535C0613D6
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 07:31:48 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id g20so16536831ejb.1
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 07:31:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=AcrMK4/n37JI/DMV0HjZEiX27NSebyROaT8OWAvMNBw=;
        b=vtSV1iHT0efi46wPfoJpuFg1nK2bdC/VzZA6MRjeXr1xW4qXgjpUGnl/2DfzffR/6/
         2RhvKNb8QtR1MQiK1sL0gmZqgPriuym2CnvE/h1lFPPG8zMZBiTcOQnmNwaGq2+42B97
         /sZmH6KbGt5e+O+Xe/2iNo4yC4+jTEEUR/+CHdTVe+UzwPGha3xnIieQKElNxosqMSg5
         feiWxe713A0J2j5iiz6vS6hCjZ+yLdoi1SDMZV4jP2trxmdxtC9qqWdATGs7mAEZXtYx
         aPqbSA8VtDjqFsdQj/hezVvJbpVenDkJjT2ZZM2ntHE1SPYMDsJaEm5/vg2vBge2y4RP
         +Y3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=AcrMK4/n37JI/DMV0HjZEiX27NSebyROaT8OWAvMNBw=;
        b=auPtDuLxlH+9rNE9owlpLeKHuHhsZlOXY4EXf3MDKwil6J1LZPbSIXTdqTu86QCAab
         rPGmd27lnVHRQCzgLZcgvbwIVyJ3v7rw3epW0lsn/+ZEcfj9uGBKDva9b0/9FDxHZEfm
         cDTy2bMS+FHUwM8Pes29GWjXYRpCQultZ7ivt85VaBRWS/xT/gU3gbDGLTabuCoudwVd
         WNKf7F7Qw8m5B8X+l44las9Iya8hl4sqoRNehExSjoQz3eyaZU0ojYhIEmsUTpYOcbOh
         pfDR6pnr4DJ/a4tovlMWzV6Vir4Cb27/LiFaZjwOz42LEky4mnGsJ2WHe7UvgOLOrLPZ
         hljg==
X-Gm-Message-State: AOAM53309NmSdP2/WRP5eFYxnsHSurAzTzHO8SIOcGhz+tqOtWhSUWZ+
        Kq4mDDhRqAKZ8aPZV2Wpe3UlBFEoZ2C5ZqWA9PBXgA==
X-Google-Smtp-Source: ABdhPJzdlRnKPfltvgEaKD8UIUmf7/DVijDULyHyNuR0R44sfbTuQ/Mi4ZzCT2fxkH8xmbbhZjQAC8DNvtrD5zyXVEg=
X-Received: by 2002:a17:906:40d3:: with SMTP id a19mr15228361ejk.98.1607787107557;
 Sat, 12 Dec 2020 07:31:47 -0800 (PST)
MIME-Version: 1.0
From:   Victor Stewart <v@nametag.social>
Date:   Sat, 12 Dec 2020 15:31:36 +0000
Message-ID: <CAM1kxwgKVrpV-4UV5wKyEGbh61N1Bb1s0=pkK8kSp6Z-i3zTKg@mail.gmail.com>
Subject: [PATCH 1/3] add PROTO_CMSG_DATA_ONLY to __sys_sendmsg_sock
To:     io-uring <io-uring@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        netdev <netdev@vger.kernel.org>,
        Stefan Metzmacher <metze@samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add PROTO_CMSG_DATA_ONLY whitelisting to __sys_sendmsg_sock

Signed-off by: Victor Stewart <v@nametag.social>
---
 net/socket.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index 6e6cccc2104f..6995835d6355 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2416,9 +2416,11 @@ static int ___sys_sendmsg(struct socket *sock,
struct user_msghdr __user *msg,
 long __sys_sendmsg_sock(struct socket *sock, struct msghdr *msg,
                        unsigned int flags)
 {
-       /* disallow ancillary data requests from this path */
-       if (msg->msg_control || msg->msg_controllen)
-               return -EINVAL;
+       if (msg->msg_control || msg->msg_controllen) {
+               /* disallow ancillary data reqs unless cmsg is plain data */
+               if (!(sock->ops->flags & PROTO_CMSG_DATA_ONLY))
+                       return -EINVAL;
+       }

        return ____sys_sendmsg(sock, msg, flags, NULL, 0);
 }
