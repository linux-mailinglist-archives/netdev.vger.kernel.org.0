Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89B605F9D45
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 13:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbiJJLEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 07:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbiJJLEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 07:04:24 -0400
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC92EDFAC;
        Mon, 10 Oct 2022 04:04:23 -0700 (PDT)
Received: by mail-il1-f173.google.com with SMTP id a2so5458627iln.13;
        Mon, 10 Oct 2022 04:04:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jTf+OgVEekYOCCjz9fIdROEP9i0Kj5DJI/WN/pZXFWI=;
        b=xl7ob7p5QUqrTsR9iZgnp7cwBfQ1Kh5lUKTM54d9lByeHUv4ApK8muUz0GauJa3CUb
         2KiqKVDPpCTW0dS5ImeMNFxZ6v2xnjqHJWgcvWT/NK1vjb4rZnICIU5JE1dlACzQhDEZ
         8Ot3cIMM8wZ+B1ruilgzuscpjwbyWmthWHRwQ9Prd2HL1iRV5mgivjiq/TeOKzGL6iSG
         jI2FVp1qquwy2rogTCuF+ys6VFRQ12Kt7QSBD5C02exVfAuAOKevRgiHg3EksBXw1DZN
         RzHGZqIfr5axdbJ6t9fh+CaUy6ahlOb12WdFWSToa7p/h/rcecSzW53ZmFjyyx017pQ8
         NOeQ==
X-Gm-Message-State: ACrzQf2RkQTC95VO3IeQiaJgEvEGYf91uZKGY8SREqLuaMW9b7h+E/9b
        JlBIV7BbBSqfpZW2HLg0e9jqXq/Ca8MscjT79UMMfOtDeq4=
X-Google-Smtp-Source: AMsMyM7hT0YDR/uglyCdWH6aETH2/GuH+utE6/mMV8y+p4EyTtqvfUbny4QcJnz96xW9a4BYt0mUhyZ30ms5hSVjY3I=
X-Received: by 2002:a05:6e02:1d03:b0:2f9:d1e5:fe16 with SMTP id
 i3-20020a056e021d0300b002f9d1e5fe16mr8776433ila.60.1665399863021; Mon, 10 Oct
 2022 04:04:23 -0700 (PDT)
MIME-Version: 1.0
References: <20211103164428.692722-1-mailhol.vincent@wanadoo.fr>
 <20211103164428.692722-4-mailhol.vincent@wanadoo.fr> <20221007074456.l2sh3s2siuv2a74m@pengutronix.de>
In-Reply-To: <20221007074456.l2sh3s2siuv2a74m@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Mon, 10 Oct 2022 20:04:12 +0900
Message-ID: <CAMZ6Rq+qD=bi8MKXvjJuH1Bs=nnuyrG1F1ZGm_0U+A_GQDhDSw@mail.gmail.com>
Subject: Re: [PATCH iproute2-next 5.16 v6 3/5] iplink_can: use PRINT_ANY to
 factorize code and fix signedness
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri. 7 Oct. 2022 at 16:56, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 04.11.2021 01:44:26, Vincent Mailhol wrote:
> > Current implementation heavily relies on some "if (is_json_context())"
> > switches to decide the context and then does some print_*(PRINT_JSON,
> > ...) when in json context and some fprintf(...) else.
> >
> > Furthermore, current implementation uses either print_int() or the
> > conversion specifier %d to print unsigned integers.
> >
> > This patch factorizes each pairs of print_*(PRINT_JSON, ...) and
> > fprintf() into a single print_*(PRINT_ANY, ...) call. While doing this
> > replacement, it uses proper unsigned function print_uint() as well as
> > the conversion specifier %u when the parameter is an unsigned integer.
> >
> > Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
>
> [...]
>
> >       if (tb[IFLA_CAN_TERMINATION_CONST] && tb[IFLA_CAN_TERMINATION]) {
> > @@ -538,29 +483,21 @@ static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
> >                       sizeof(*trm_const);
> >               int i;
> >
> > -             if (is_json_context()) {
> > -                     print_hu(PRINT_JSON, "termination", NULL, *trm);
> > -                     open_json_array(PRINT_JSON, "termination_const");
> > -                     for (i = 0; i < trm_cnt; ++i)
> > -                             print_hu(PRINT_JSON, NULL, NULL, trm_const[i]);
> > -                     close_json_array(PRINT_JSON, NULL);
> > -             } else {
> > -                     fprintf(f, "\n    termination %hu [ ", *trm);
> > -
> > -                     for (i = 0; i < trm_cnt - 1; ++i)
> > -                             fprintf(f, "%hu, ", trm_const[i]);
> > -
> > -                     fprintf(f, "%hu ]", trm_const[i]);
>                                         ^
> > -             }
> > +             can_print_nl_indent();
> > +             print_hu(PRINT_ANY, "termination", " termination %hu [ ", *trm);
>
> Always '['
>
> > +             open_json_array(PRINT_JSON, "termination_const");
> > +             for (i = 0; i < trm_cnt; ++i)
> > +                     print_hu(PRINT_ANY, NULL,
> > +                              i < trm_cnt - 1 ? "%hu, " : "%hu",
> > +                              trm_const[i]);
> > +             close_json_array(PRINT_JSON, " ]");
>
> ']' only for JSON.

Thanks for the report

Actually, the second argument of close_json_array() is what should be
printed for the normal (non-json) output. Here it is correctly set to
" ]". *However*, this parameter gets ignored because the first
argument is PRINT_JSON instead of PRINT_ANY.

This is a lack of testing on my side (I do not have hardware which
supports the switchable termination resistors). After investigation,
the bitrate and dbitrate also have the same issue.

This is fixed in
https://lore.kernel.org/linux-can/20221010110118.66116-1-mailhol.vincent@wanadoo.fr/

> >       }
>
> I just noticed that the non JSON output for termination is missing the
> closing ']'. See the output in the documentation update by Daniel:
>
> | https://lore.kernel.org/all/4514353.LvFx2qVVIh@daniel6430

Yours sincerely,
Vincent Mailhol
