Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3734D8B9D
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 19:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242501AbiCNSVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 14:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238339AbiCNSVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 14:21:08 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E2F344EA
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 11:19:56 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id b28so17045860lfc.4
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 11:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version:content-transfer-encoding;
        bh=geuK6O1BF0Rx33QJa1RoEy9NmWQcnn7KyrQFh2cV83A=;
        b=S492tODRvcBTpzmv7JdlnRro38XB10gHPN3O2VN6GRxQHaMoQ5gDvybM49PWnKmI8b
         GYowuMzPIHrwhBrJTH+yAZXWlqWLrxuEtd8ADx5yLOAhroW9IJSh0XLrhB7VCZKwNFVt
         RIX1ozn8qsRV5dqibsiouyn8AeyikR7TSkR0I+qXl9xW8Yz+hiCh4tvKoWdtY5alIe7G
         3t1FgdoxXYDW0Ulh8eGuOQ2P0Ve7TEVELdwQnR90/p/gfMwJXXcb18r4+Ray43PX3yXY
         rf/t4+eQC10xtPIbkn5UYEHIdbI14FuP1ME2thDcGql6sh+Zk26vXtyXTu4u1BgA3oE7
         h9IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=geuK6O1BF0Rx33QJa1RoEy9NmWQcnn7KyrQFh2cV83A=;
        b=fUCss3kzUv3YrYU6JFu448/BI1Gwh3/8WXUJA05RkOPsQ6Xtf+PF+PS8/xeenGqXvV
         oRbDndyNthIqmOanziNU7Wo+ILt1LTayUSrUvzJLB6wW6+2pI1jATD4Hx8HT1/9ENwPP
         H/3CDFapCwukVf5OQDm/D2eVeSIu9kUtx8F6z3vcZ8wdV8vNuzMijC+9ROggrhjAV0Y0
         CJs2/FYfuoxTp5NOAMMwtyLSx51FlaFuGDi8XsSh/yycLloMpB5vhQfveeYX6gKgA1Ue
         d8qK3y9VFhlRiNK1Okk+ufSwOz26bnksf7urEEiv6QdDe8DdQ9rMq+n6zjNT25l3qORE
         PblA==
X-Gm-Message-State: AOAM530H/zxCsTWtWlfTIF4GWsjFqRAEzCtai65YHBsqCCpLLzI+ZTlc
        r3NrEjHUEUh9sTGvT8tXXgnD7w==
X-Google-Smtp-Source: ABdhPJxkYqW+JynktuAgynNq4Kroz6eT0lasbENz+cTYFKMfTpFtW/rqPlC/9KbMKGxBzDIqHMVgXw==
X-Received: by 2002:a05:6512:3243:b0:445:79a1:b589 with SMTP id c3-20020a056512324300b0044579a1b589mr14294424lfr.191.1647281994635;
        Mon, 14 Mar 2022 11:19:54 -0700 (PDT)
Received: from wkz-x280 (h-212-85-90-115.A259.priv.bahnhof.se. [212.85.90.115])
        by smtp.gmail.com with ESMTPSA id q11-20020a2e914b000000b00244c6c98416sm4110205ljg.76.2022.03.14.11.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 11:19:54 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Marek =?utf-8?Q?Beh=C3=BAn?= <kabel@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Jan =?utf-8?B?QsSbdMOtaw==?= <hagrid@svine.us>
Subject: Re: [PATCH net] net: dsa: fix panic when port leaves a bridge
In-Reply-To: <20220314190926.687ac099@dellmb>
References: <20220314153410.31744-1-kabel@kernel.org>
 <87tuc0lelc.fsf@waldekranz.com> <20220314174700.56feb3da@dellmb>
 <20220314190926.687ac099@dellmb>
Date:   Mon, 14 Mar 2022 19:19:52 +0100
Message-ID: <87r174l7lj.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 14, 2022 at 19:09, Marek Beh=C3=BAn <kabel@kernel.org> wrote:
> On Mon, 14 Mar 2022 17:47:00 +0100
> Marek Beh=C3=BAn <kabel@kernel.org> wrote:
>
>> Tobias, I can backport these patches to 5.4+ stable. Or have you
>> already prepared backports?
>
> OK the patches are prepared here
>
> https://secure.nic.cz/files/mbehun/dsa-fix-queue/

Great, thank you!

Not sure what the procedure is here, any action required on my part?
