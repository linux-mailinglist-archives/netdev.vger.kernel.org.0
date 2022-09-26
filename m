Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BADF35EB4A7
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 00:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiIZWkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 18:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbiIZWkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 18:40:31 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A2851427;
        Mon, 26 Sep 2022 15:40:29 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id c7so9031510ljm.12;
        Mon, 26 Sep 2022 15:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=y72XdXz6R5ZX/ARjJcZ26pw4EoyPBrU9yVa6+CTk8aU=;
        b=MUbphOcrpdLt5Iomx0drL3eOcQehL/fsyiEdAkz7QzmABbebFY7hoTuj00cvws+kQb
         xdkQ7b5thEBkfj+yxxLT2UtP/Jlkz1uhSvDSgbkTR7NPFW8LG0NmyQB4gr/YmngT3CdE
         oZKo3e09DksH1ZBc0B/lYsVvf8l99rwiHoHE8K1DPOU7wP3qn+38DPYtARw/uDpIqJws
         kFyEkWHl4TFB/zConA/M2BLF+dxBVsC4VCgis8TNOSaH/XoKG5FdqRt3bdUfptxQY+pp
         5AkIxUrWdYm8oOS3DNXwumRi/Pp1I+3aXZ1ig1ad9KVWTsr23F5TzvcRMaWzoXMl/wNY
         RzUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=y72XdXz6R5ZX/ARjJcZ26pw4EoyPBrU9yVa6+CTk8aU=;
        b=EoJ5o9IGyFaPCDv8AiHT9Y8DU+TRtrLfuVdfF5pyVLQwREwbnefB/aUxJG+wxvoe+L
         0NVmhABjjBDi6YSPsZpaIs9T3YEpaZwZWh5lolzgNPg9L5H7/nkbyuoEn7YzqEZMjaZK
         oVUX6uKlhwOxveeTO0frxgDtp6z01o/jUOiyCrw1Lsr7qgGRZcGipzXT+KlU4qePPFZx
         zcTnKS+aCP+mm5ehNfU1ZWw8AuA7kkzsGmEkAAl/diMjyBMvz0Gfwcny/mjeYNDJcVTk
         lpPGR4B38hxzRCHerD4p6hB83tI0neSYilspJxmj2gxLDI5hn5bdsksjT8DzGAKzW7AD
         SYyg==
X-Gm-Message-State: ACrzQf2Ffzuj/BhwGCmIP7jZAJ7D5E3Ax3N2ztvCUbC25d4U15AyvldZ
        uLWQG+Jz2UJKTdjjeexZbubH9oOlg5yBU5jyVm8=
X-Google-Smtp-Source: AMsMyM5W3/lV0mq0BREkCl59rHi1NZjUjoS6a/j3YY+f9eMLjaOBimG9gR98iWI/mtzQCNT2AD7QEJIr4upKEDPk1AI=
X-Received: by 2002:a2e:a884:0:b0:25d:d8a2:d18c with SMTP id
 m4-20020a2ea884000000b0025dd8a2d18cmr7917320ljq.305.1664232027695; Mon, 26
 Sep 2022 15:40:27 -0700 (PDT)
MIME-Version: 1.0
References: <CABBYNZLdvOzTwnHp4GX9PiXVMr2SDjD1NCXLRJw1_XLvSuZyjw@mail.gmail.com>
 <20220926220212.3170191-1-iam@sung-woo.kim>
In-Reply-To: <20220926220212.3170191-1-iam@sung-woo.kim>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 26 Sep 2022 15:40:15 -0700
Message-ID: <CABBYNZ+C_N=vSE6oUn2rDHq5EHCFtAAjtohbcpjMtKwwgqpqUQ@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: L2CAP: fix an illegal state transition from BT_DISCONN
To:     Sungwoo Kim <iam@sung-woo.kim>
Cc:     davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, marcel@holtmann.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kim,

On Mon, Sep 26, 2022 at 3:06 PM Sungwoo Kim <iam@sung-woo.kim> wrote:
>
> Signed-off-by: Sungwoo Kim <iam@sung-woo.kim>
> ---
>  net/bluetooth/l2cap_core.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> index 2c9de67da..029de9f35 100644
> --- a/net/bluetooth/l2cap_core.c
> +++ b/net/bluetooth/l2cap_core.c
> @@ -4294,13 +4294,13 @@ static int l2cap_connect_create_rsp(struct l2cap_conn *conn,
>         mutex_lock(&conn->chan_lock);
>
>         if (scid) {
> -               chan = __l2cap_get_chan_by_scid(conn, scid);
> +               chan = l2cap_get_chan_by_scid(conn, scid);
>                 if (!chan) {
>                         err = -EBADSLT;
>                         goto unlock;
>                 }
>         } else {
> -               chan = __l2cap_get_chan_by_ident(conn, cmd->ident);
> +               chan = l2cap_get_chan_by_ident(conn, cmd->ident);
>                 if (!chan) {
>                         err = -EBADSLT;
>                         goto unlock;
> @@ -4336,6 +4336,7 @@ static int l2cap_connect_create_rsp(struct l2cap_conn *conn,
>         }
>
>         l2cap_chan_unlock(chan);
> +       l2cap_chan_put(chan);
>
>  unlock:
>         mutex_unlock(&conn->chan_lock);
> --
> 2.25.1

Not quite right, we cannot lock conn->chan_lock since the likes of
l2cap_get_chan_by_scid will also attempt to lock it:

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 770891f68703..4726d8979276 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4293,26 +4293,18 @@ static int l2cap_connect_create_rsp(struct
l2cap_conn *conn,
        BT_DBG("dcid 0x%4.4x scid 0x%4.4x result 0x%2.2x status 0x%2.2x",
               dcid, scid, result, status);

-       mutex_lock(&conn->chan_lock);
-
        if (scid) {
-               chan = __l2cap_get_chan_by_scid(conn, scid);
-               if (!chan) {
-                       err = -EBADSLT;
-                       goto unlock;
-               }
+               chan = l2cap_get_chan_by_scid(conn, scid);
+               if (!chan)
+                       return -EBADSLT;
        } else {
-               chan = __l2cap_get_chan_by_ident(conn, cmd->ident);
-               if (!chan) {
-                       err = -EBADSLT;
-                       goto unlock;
-               }
+               chan = l2cap_get_chan_by_ident(conn, cmd->ident);
+               if (!chan)
+                       return -EBADSLT;
        }

        err = 0;

-       l2cap_chan_lock(chan);
-
        switch (result) {
        case L2CAP_CR_SUCCESS:
                l2cap_state_change(chan, BT_CONFIG);
@@ -4338,9 +4330,7 @@ static int l2cap_connect_create_rsp(struct
l2cap_conn *conn,
        }

        l2cap_chan_unlock(chan);
-
-unlock:
-       mutex_unlock(&conn->chan_lock);
+       l2cap_chan_put(chan);

        return err;
 }


-- 
Luiz Augusto von Dentz
