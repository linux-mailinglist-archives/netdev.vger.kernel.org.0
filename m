Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 138E26A27E5
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 09:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjBYIev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 03:34:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBYIeu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 03:34:50 -0500
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D40612F0A;
        Sat, 25 Feb 2023 00:34:49 -0800 (PST)
Received: by mail-pf1-f181.google.com with SMTP id g12so858121pfi.0;
        Sat, 25 Feb 2023 00:34:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tgdlhpL67h2C5/Vx2oHavtV4QOTDeiwV5fIx5a2BvQI=;
        b=FSRTIhl/hUIXtxDLGdLArexGYAzXUCdAAewokG/ZoEy+VPXTUws19p0en9BpzG72I3
         b6/JrilVDv+eYhzLETi2Z3LdJxQJAGe8JwVHE5Z/x6AuXzILmWnukilzIP+yI18T4rk6
         T4xa9Jxr58zlJ9QnPSFOVfXKI6p38zenPQaMGT2X2FMLXJ0fpdV6gypC1lZrgdfl0VhR
         8h6WTU7lCW9b4/uIzTLRpi2vrQ30pUwD1QGTzAWJxVDPGBYjpS/h8y5aeaZsL2OoIa5+
         41axWY9C99oQ3QyjuVDx3sx2/pLW5m7yPMs9KLzxuTIBUpzOXVOgJAX/uShiK+2Yj9iH
         hYAQ==
X-Gm-Message-State: AO0yUKXQZsSX6CzbXEw5iw6JLfDYuePe+QUxGYcjHkVxqHWPNu8TZHuo
        H0zIFVh7TfX0PV3OQLPbazdMu+G2JyIchF7capMID2SIW9k=
X-Google-Smtp-Source: AK7set/rSsk9JATGK69ZfTt4pxEx7Lr/OtJW7W+5zkvAsvEy9cx0/Krpl200gXh/mjn8k2Xdq1LxWnIeKuGu/DLDk9M=
X-Received: by 2002:a62:1993:0:b0:5a8:bdd2:f99c with SMTP id
 141-20020a621993000000b005a8bdd2f99cmr3757105pfz.1.1677314088667; Sat, 25 Feb
 2023 00:34:48 -0800 (PST)
MIME-Version: 1.0
References: <20230222163754.3711766-1-frank.jungclaus@esd.eu>
In-Reply-To: <20230222163754.3711766-1-frank.jungclaus@esd.eu>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Sat, 25 Feb 2023 17:34:37 +0900
Message-ID: <CAMZ6RqJwJNxn5nm-PW2yY3BobTNB+vVmeDGi=M80YavN8Ui-OQ@mail.gmail.com>
Subject: Re: [PATCH] can: esd_usb: Improve code readability by means of
 replacing struct esd_usb_msg with a union
To:     Frank Jungclaus <frank.jungclaus@esd.eu>
Cc:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        =?UTF-8?Q?Stefan_M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu. 23 Feb. 2023 at 01:56, Frank Jungclaus <frank.jungclaus@esd.eu> wrote:
> As suggested by Vincent Mailhol, declare struct esd_usb_msg as a union
> instead of a struct. Then replace all msg->msg.something constructs,
> that make use of esd_usb_msg, with simpler and prettier looking
> msg->something variants.
>
> Link: https://lore.kernel.org/all/CAMZ6RqKRzJwmMShVT9QKwiQ5LJaQupYqkPkKjhRBsP=12QYpfA@mail.gmail.com/
> Suggested-by: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
> Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>

Thank you for your follow up on this and on all my other comments.

Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
