Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84E5A5344B2
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 22:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241693AbiEYUHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 16:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236566AbiEYUHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 16:07:30 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351245FC9
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 13:07:29 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-2ff7b90e635so160533187b3.5
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 13:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i2SdZwRnO7AZeugCPG1VVs3s8P5NGEW9+pFGDARsxpU=;
        b=h5fj5qLGE4k1qCVrSTbtszUHXCn3jSMKMKuaHOlxoXJADhs5My1nKEbuGa4vOr0Ggm
         T+T6dnHlF5iDUb83OFV9QHeWYOrrhcs/8pmfJmlRHlwnRUv5JTXBfk7ZSAcAkb1OlfOb
         cW4ozXVrpKkB/W625cYCXzbpXuXVtHosU9YcYz5+0P2ZMy/zYSu/oRy5UkQ7VrvHWmvZ
         mXb8qge3S+tZ3iuiXYIJ146rAicw5QvrES5KVxoHdSvihUStTt51vwwZ9ck9m49jkTs2
         p3wr86PsE4atqmB+oTt0LmqDstDAjGkBPBuQ73tjV0GulqagOS1iqn6x3YJfpK9zcx1l
         /LwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i2SdZwRnO7AZeugCPG1VVs3s8P5NGEW9+pFGDARsxpU=;
        b=ehpr7slnfHLm79SIZb/PQsSad3I5edWNJ1CUlzXUAET7DVD6LSAOAB0/+RhMENwsvm
         A8x240KSlIzy3JcPK9leXYtt580pTHDouaMwsM8MZQKYDLv41jaMQXPn7gz0PhWAeK1O
         x+nLePVDdTUdzHymifCVTNJHq0nzvqD1z916u+9rXTNnoY88egFNpjoSo6GM41KOZlhw
         yM7zrRvC6Nm77C7Xu0OTIo31oQaYQrZzeCtImmGo/agIX+Idjl+5+DKKD2OLwSOas9dS
         2uPd6uW7fYNVmD5puW96OBL++cq4RwJFQY67hGmsoh8KpuZ4XoXEsdOpsWJ8iqsaRFMt
         MLow==
X-Gm-Message-State: AOAM530NtGdELmgWoatq+Gu1rVFKPSm3IzmL9ZwegdlhWavC0+AHq1WS
        QwfwRDEozZCqH0UMZlfdhkDN1ZWh8dc0b7IR1hs=
X-Google-Smtp-Source: ABdhPJy2NNtEvH9EAfZFrsKrQoYpy8pq4lMrG05GVvub+S+QnDi4xQMcq+uRTLiaLmOBjfomi5E/CvcoMA6mjgRipjM=
X-Received: by 2002:a0d:d741:0:b0:300:62eb:2362 with SMTP id
 z62-20020a0dd741000000b0030062eb2362mr2881133ywd.477.1653509248490; Wed, 25
 May 2022 13:07:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220523202543.9019-1-CFSworks@gmail.com> <76f1d70068523c173670819fc9a688a1368bfa12.camel@redhat.com>
In-Reply-To: <76f1d70068523c173670819fc9a688a1368bfa12.camel@redhat.com>
From:   Sam Edwards <cfsworks@gmail.com>
Date:   Wed, 25 May 2022 14:07:17 -0600
Message-ID: <CAH5Ym4gm49mkMUKzyPqKT8vt3M67NZB-zoep3bu+VB3FbuVzCQ@mail.gmail.com>
Subject: Re: [PATCH] ipv6/addrconf: fix timing bug in tempaddr regen
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>
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

Bah, I've had to resend this since it went out as HTML yesterday.
Sorry about the double mailing everyone!

On Tue, May 24, 2022 at 3:24 AM Paolo Abeni <pabeni@redhat.com> wrote:
> I looks like with this change the tmp addresses will never hit the
> DEPRECATED branch ?!?

The DEPRECATED branch becomes reachable again once this line is hit:
ifp->regen_count++;
...because it causes this condition in the elseif to evaluate false:
!ifp->regen_count
