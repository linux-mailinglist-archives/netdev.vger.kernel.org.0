Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2374F4E5367
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 14:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244432AbiCWNmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 09:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244428AbiCWNmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 09:42:35 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 539907DA9B
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 06:41:04 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-2d07ae0b1c0so17584327b3.2
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 06:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9jCDAcUtteKlAN5udZM1zvoRPaSXlwCPmGJqPYhPGNk=;
        b=Nv5l3nkAfmDXMDqGcxm6rv77B/vDaPFKLwxNIYW1dXBIIP4MIpW0nqUD9X0R8tlL8O
         T2SRHm5VUnTa4/pQ3L0z9tu8tAnHAuDuhMeBi5GMba7zhajevoECEAg+NDV1Vsa3fj79
         K7YHw7NTMuZ1crmk8vSOBoMXn1ChM/JmI7y/gZWJt8niLU5QQyFuiDRZ4J7Imd57Z8VL
         pBVmkkmZxFRW2TEOSEBEj/ZbvZ00JU5yOeLmzsTjxuZq1EPRWAzqbLDPsLwsN2RJf8KK
         hoENJcFu6htu42K6IRvony/ygkmMdl7JhqY3YyEtJOw7LZmR+RBl0gxtfHIGTOwbmjnD
         nxtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9jCDAcUtteKlAN5udZM1zvoRPaSXlwCPmGJqPYhPGNk=;
        b=bKaJUurApW1i8eC185NspMiWroGwAmL+VvxBD8XJnmTFdIaE3n902bYAaQXNjqIwiD
         YFj5P5ZAGa2Bu2H8xczvPt/Ls0uD1bQhwol0P0BQxNdK9GMDroRwdA3GKrU1rFW1uu7T
         oQtDuVwNn0UFT8A61skJQkvTSEoFRXjQzyG3Q+XoLX2cnbARuY117XmPw1DV9O+R5Gtd
         Tz7PvhUzC5yqH5vPIqLtgsRj/JWb7cP/44U2sKB26Ot7G1vEBqKx3b2Bt2TwxxFn5vP4
         9stk5u+Rcd2a2dSX0KQV8j82np2xnW+/3sRqmzkzVdU0D2wXcsjaQG89/Buu9uSn6Uvi
         f1Vw==
X-Gm-Message-State: AOAM531XrZTCU8uTIEyX4yiIwlQyEKgReUJa5P+vKfy1DVA9z+zw1ySq
        VlR6e8NHvTLui69SOb17eCDth1T4MoBMVcl2iv4eSA==
X-Google-Smtp-Source: ABdhPJxQzRDwWesyRaLs2HSP1XDiI0WQTTuz0HmiEEK+3gnkhoSs92iC2Hl5reOS8kNNSxVJKFhZrtdiBwQXT1Q33X4=
X-Received: by 2002:a81:680a:0:b0:2e5:b7ba:f8ee with SMTP id
 d10-20020a81680a000000b002e5b7baf8eemr34162743ywc.55.1648042862993; Wed, 23
 Mar 2022 06:41:02 -0700 (PDT)
MIME-Version: 1.0
References: <3eb95fd0-2046-c000-9c0b-c7c7e05ce04a@163.com>
In-Reply-To: <3eb95fd0-2046-c000-9c0b-c7c7e05ce04a@163.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 23 Mar 2022 06:40:51 -0700
Message-ID: <CANn89i+v=yOd8=-i9cd=vL9U7Q8W0RRNco6CVFv4+Cx6Dj0z5A@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: make tcp_rcv_state_process() drop monitor friendly
To:     Jianguo Wu <wujianguo106@163.com>
Cc:     David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Menglong Dong <menglong8.dong@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 23, 2022 at 6:05 AM Jianguo Wu <wujianguo106@163.com> wrote:
>
> From: Jianguo Wu <wujianguo@chinatelecom.cn>
>
> In tcp_rcv_state_process(), should not call tcp_drop() for same case,
> like after process ACK packet in TCP_LAST_ACK state, it should call
> consume_skb() instead of tcp_drop() to be drop monitor friendly,
> otherwise every last ack will be report as dropped packet by drop monitor.
>
> Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
> ---

1) net-next is closed

2) Same remarks as for the other patch.
   You mark the packet as consumed, while maybe we had to throw away
some payload from it ?

You will have to wait for net-next being open,
then send patches with one change at a time, with clear explanations
and possibly packetdrill tests.

I am concerned about all these patches making future backports
difficult because of merge conflicts.
