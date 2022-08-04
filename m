Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F8158A0A8
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 20:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240037AbiHDSnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 14:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232592AbiHDSm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 14:42:59 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A3961DBE;
        Thu,  4 Aug 2022 11:42:58 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id s11so709111edd.13;
        Thu, 04 Aug 2022 11:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=l2WvlJVDhkRnr1kbEx9moKytaqwORKO3J141YHwAb6I=;
        b=C9p6a3bOmYkZXm4m8ANQX/jZMCp+PePUdKvcdx7dd3FfWAHZbmUF59CqdEBTXdrvZK
         KihLsfhZTT2f8RYHepGGEI3PHe/FvbAF2ypggB6fqZ+Bw787JQ+cDBSB4oJh73DQYEw9
         N8rpgwSo5Lk4CXvcsgAzyOkrEM6PwVDZSOez7ikAAMm3KHun7cmKtYSLrRKtXcp/6n/E
         WgcwfnARYD4u32xtevrqc6NT/YAjLCBO8w/dKB8shtAiA7GkLgiei7pKRDfxd+GoteDY
         Dlv56/bU48dBm8KsDT48PS4JNuWrTloMAc+a31/E+hFn9jON3i9dfSErtrQomly9YnQR
         XA+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=l2WvlJVDhkRnr1kbEx9moKytaqwORKO3J141YHwAb6I=;
        b=3bfH5a8KpLioEiRMyNriHUD+O2Klu/tUdX6iiF9vksMs/+nTmq57D/N6WJzTjwDxlv
         /sfwTTMRcI1Oc7k+pLbB16UOrAdVGHn9Ar1mpVUmfFq4aQrQgU4n8H5nG9rlSYyFnkt4
         i+s/lTFxaQy8n9mYelL14qcoWJIoQdBTrbuQJYlPPqzhJvuz6QREJpMJd/uC1GLHz3ec
         uzZk3aAxN9oaSaG/ujzXA7/5OK2C/g3Eh+MBFP2wpXdVVAXZrS1zK2rCwfcFcX9Sn7Ay
         E+pDo+CbPb0kzJz9Y3S1d7UPab7LUSR49Mx+rmr3E8I5N2HRZM9/6g7pWeOYrNXk8lK/
         XUxg==
X-Gm-Message-State: ACgBeo2KtPtBPa+7C66n2mdQEw6FjiVKNgODHktPfW+PtvkDN3Y7wgWG
        bMziWFmv456FjXoc/+awpqdvTRRZ6ZgUlHhQsBw=
X-Google-Smtp-Source: AA6agR4xrhY8CkbvzMI/2yxpfhJyHTlze7LkU7wCxGPSzHmnYvPO5jAXRMgZ0VJbIsrYVtAE4OdFoqvgP3iI35n7Snc=
X-Received: by 2002:a05:6402:40c3:b0:43b:d65a:cbf7 with SMTP id
 z3-20020a05640240c300b0043bd65acbf7mr3396726edb.380.1659638576599; Thu, 04
 Aug 2022 11:42:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220804075914.67569-1-sebastian.wuerl@ororatech.com> <20220804081411.68567-1-sebastian.wuerl@ororatech.com>
In-Reply-To: <20220804081411.68567-1-sebastian.wuerl@ororatech.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 4 Aug 2022 20:42:19 +0200
Message-ID: <CAHp75Vf8VtN5pLDLVrNGKUmq3W=gY8u9jsKX+AqR4UjmmR7zvw@mail.gmail.com>
Subject: Re: [PATCH v4] can: mcp251x: Fix race condition on receive interrupt
To:     =?UTF-8?Q?Sebastian_W=C3=BCrl?= <sebastian.wuerl@ororatech.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        =?UTF-8?Q?Stefan_M=C3=A4tje?= <stefan.maetje@esd.eu>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Christian Pellegrin <chripell@fsfe.org>,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 4, 2022 at 10:42 AM Sebastian W=C3=BCrl
<sebastian.wuerl@ororatech.com> wrote:
>
> The mcp251x driver uses both receiving mailboxes of the CAN controller
> chips. For retrieving the CAN frames from the controller via SPI, it chec=
ks
> once per interrupt which mailboxes have been filled and will retrieve the
> messages accordingly.
>
> This introduces a race condition, as another CAN frame can enter mailbox =
1
> while mailbox 0 is emptied. If now another CAN frame enters mailbox 0 unt=
il
> the interrupt handler is called next, mailbox 0 is emptied before
> mailbox 1, leading to out-of-order CAN frames in the network device.
>
> This is fixed by checking the interrupt flags once again after freeing
> mailbox 0, to correctly also empty mailbox 1 before leaving the handler.
>
> For reproducing the bug I created the following setup:
>  - Two CAN devices, one Raspberry Pi with MCP2515, the other can be any.
>  - Setup CAN to 1 MHz
>  - Spam bursts of 5 CAN-messages with increasing CAN-ids
>  - Continue sending the bursts while sleeping a second between the bursts
>  - Check on the RPi whether the received messages have increasing CAN-ids
>  - Without this patch, every burst of messages will contain a flipped pai=
r

For future submissions...

> Fixes: bf66f3736a94 ("can: mcp251x: Move to threaded interrupts instead o=
f workqueues.")
> Signed-off-by: Sebastian W=C3=BCrl <sebastian.wuerl@ororatech.com>
> ---

When you send the new version of a single patch, use --annotate to put
a changelog here (after the cutter '---' line) so people will know how
v4 differes to v3 to v2 and to v1.


Also you mentioned some issues with the mail program. Use `git
send-email` for patch submission. Also you may consider my "smart"
(no) script [1] for that.

[1]: https://github.com/andy-shev/home-bin-tools/blob/master/ge2maintainer.=
sh


--=20
With Best Regards,
Andy Shevchenko
