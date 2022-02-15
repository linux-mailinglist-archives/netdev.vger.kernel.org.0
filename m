Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2584B6C0A
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 13:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237584AbiBOMaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 07:30:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236596AbiBOMaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 07:30:23 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43939107D13
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 04:30:14 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id j12so33277277ybh.8
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 04:30:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=nEBxpoV3vW03GgpeF1rAwShLZRERiYrr7ByXykQZSfs=;
        b=RJvB+MV89/fr68L9OlFOHxWNuuNdAJVHUd6ra3iXeOXfO139tUe4omuldWiKrmIe8l
         6hm8o9mZOY6WwJX1u3c3ttd2oAHjBCTpz/7ID37MJjsm/LeQfydS6jSmf/pR101otcOR
         DyW/8k9qI9NT3KN6TixFplrDcYGG9uKhk1AxqapKmFXulDgkLxOd21MBG9QtRlp/LK2D
         v9CBznuYGTQZGkN0yj2Ta5KxA1IfcmTv5YOhm/RjFSk6YA6cN3LZK/6/xbj3F/r5HN1Y
         uvR0DEW5wE21jVrdIUqj7/blL4NIx+ECR2ieMvknAn/9SgmRgxtylGUh2YoT0IAYOsF/
         R+2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=nEBxpoV3vW03GgpeF1rAwShLZRERiYrr7ByXykQZSfs=;
        b=kNGOhUifAJDZ2FJGxQKLw9wh79OniIJ0+GUWioSV/0c7GKsGVzt5XihGAG+bxqrd0w
         JLbJcJOVRPCYQuEoYLZBgpb7QdkcIKPcWHI1mPqZJnLbKjbu7a7G51W5E+3G/+xMKy9b
         S23qK/X5xMudT2wMfd2JYZ5KsNXrVabS7dy6b375dQfeY3zzKy2fV7waBr3QH9V2qlXM
         XQ6LU6+kaKoO4E/bqkRFmu8DbAQLU3ndH+WLc3arPldE3/LiFMuhUK0a4p5fRMoM8Y/8
         EWcukxl2uTum2hm/JWu9rE/TKg1idk6zXpSTQr1eydX4sTM8pgi4lhNldJ/fgO5v6mO5
         oXsA==
X-Gm-Message-State: AOAM533VX+8pUFnI0iTqAGzxBB9fPXb2f1xHWxWeb4h20eS8Fku5aKUI
        yVghrE1ftJ3CI01evb3WTrHTaNWCH/sWLFwsvg==
X-Google-Smtp-Source: ABdhPJwOWvSx1LSgKj3bhUacKIlG5024X/lL1/STrqEKIR0LUlvUJ4m2oZR/LtAWJe56Dtj8BU/kNnaxWfloJpLn1RA=
X-Received: by 2002:a81:a7c7:: with SMTP id e190mr3490796ywh.244.1644928213447;
 Tue, 15 Feb 2022 04:30:13 -0800 (PST)
MIME-Version: 1.0
From:   Jinmeng Zhou <jjjinmeng.zhou@gmail.com>
Date:   Tue, 15 Feb 2022 20:30:02 +0800
Message-ID: <CAA-qYXgrcXsgHMoDyTR74bryDsofzPajTfT6WZHGH-vaDixDwA@mail.gmail.com>
Subject: A missing check bug and an inconsistent check bug
To:     isdn@linux-pingi.de, Jakub Kicinski <kuba@kernel.org>,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, shenwenbosmile@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear maintainers,

Hi, our tool finds a missing check bug(v4.18.5),
and an inconsistent check bug (v5.10.7) using static analysis.
We are looking forward to having more experts' eyes on this. Thank you!

Before calling sk_alloc() with SOCK_RAW type,
there should be a permission check, ns_capable(ns,CAP_NET_RAW).

In kernel v4.18.5, there is no check in base_sock_create().
However, v5.10.7 adds a check.  (1) So is it a missing check bug?

drivers/isdn/mISDN/socket.c (v4.18.5)
static int
base_sock_create(struct net *net, struct socket *sock, int protocol, int kern)
{
struct sock *sk;

if (sock->type != SOCK_RAW)
return -ESOCKTNOSUPPORT;

sk = sk_alloc(net, PF_ISDN, GFP_KERNEL, &mISDN_proto, kern);
if (!sk)
return -ENOMEM;
...
}


In kernel v5.10.7, a check is added in the same function,
base_sock_create(), which is not ns-aware. (2) Should it use ns_capable()?

drivers/isdn/mISDN/socket.c (v5.10.7)
static int
base_sock_create(struct net *net, struct socket *sock, int protocol, int kern)
{
struct sock *sk;

if (sock->type != SOCK_RAW)
return -ESOCKTNOSUPPORT;
if (!capable(CAP_NET_RAW))
return -EPERM;

sk = sk_alloc(net, PF_ISDN, GFP_KERNEL, &mISDN_proto, kern);
if (!sk)
return -ENOMEM;
...
}


Thanks again!


Best regards,
Jinmeng Zhou
