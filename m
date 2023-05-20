Return-Path: <netdev+bounces-4043-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 029C270A472
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 03:55:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0D5A1C20D3D
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 01:55:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E08862D;
	Sat, 20 May 2023 01:55:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F106262C
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 01:55:33 +0000 (UTC)
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44EF3128;
	Fri, 19 May 2023 18:55:32 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-643990c5319so2897664b3a.2;
        Fri, 19 May 2023 18:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684547731; x=1687139731;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RQLH3Pz0r24f41zJi+Y/rFTpLpmNVDUqO6m0VkTNqZQ=;
        b=HZqfno5CxT3eIpLYVJk6Qs92HXMRmJcpQID4d5EqWTu1iPBXDj3lbDSaKtxe9UGK6m
         kfk9DL+ze63ayibZZzbRk31D01m1wdzIil2GaAjwwAdZ18QC7guJjNxyE5tSzu/SO8in
         cDDH0zZuxmTHarIOUI7yBNysayZ6OFgXM49cQYAbeKfLv9EcidMjfEe4cs5ffqhPRfF3
         kvMwIfG/V7OAlU2n6LnRjN6beJaESUaVlB9Af+vzJrX/Y1UZxap4M6fgTJwpUYiR6Wju
         nDK5S3aLnUD9X+b5mBm3tPPT3eB1Cqpdj632VE6DaOfe3vG1IN7aEWkAXsJHABk1lVwX
         D7fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684547731; x=1687139731;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RQLH3Pz0r24f41zJi+Y/rFTpLpmNVDUqO6m0VkTNqZQ=;
        b=j5QVKJgjt3fx2NzpyySX0rzKWLuO+LwepwGBUHvDr2fExb5o82cX/wpQgBpPWgCtC/
         JawGHPf06EMIEz4qNLplAO5Xh6YbeGBRZ4Cg73kh56LXfb6lxjh213LBdTeW7JKIyrZw
         60djdKPwhamAim3R37KwPfocGjrQB7RMJVyBpkyd8PfiW7Xwy0DzRxQDoUv0Mzzo+SdH
         yiR1ncekMFuSh75WIEJMXQ3+gseBRxnmlXUj61sb/dv6Z+f0vFbcWg2TCoWJGXAIoPWw
         2xtzyKNIWRB/2jAJKOhxAkWnVbLuIG7Qbhf++CZbfa2Ey7rBydVJkstnwA44j4N+ErAv
         UhbQ==
X-Gm-Message-State: AC+VfDwJh7xSDem3nC0xzlKeyII45jgpLLlNvqIrygf9dzqkBmAMxvXc
	CzYDoUoWHlxsmzQegtfHpRs=
X-Google-Smtp-Source: ACHHUZ530gkeNgmhcoWvoQri+XxvWEXyMVxLz2RbkbfZlLY+IC2AiFL1CI4Q6p16HMrqEiBOK6orSA==
X-Received: by 2002:a17:903:248:b0:1a9:3b64:3747 with SMTP id j8-20020a170903024800b001a93b643747mr5197035plh.17.1684547731671;
        Fri, 19 May 2023 18:55:31 -0700 (PDT)
Received: from ubuntu777.domain.name (36-228-97-28.dynamic-ip.hinet.net. [36.228.97.28])
        by smtp.gmail.com with ESMTPSA id c9-20020a170903234900b001ac5896e96esm262638plh.207.2023.05.19.18.55.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 18:55:31 -0700 (PDT)
From: Min-Hua Chen <minhuadotchen@gmail.com>
To: kuba@kernel.org
Cc: alexandre.torgue@foss.st.com,
	davem@davemloft.net,
	edumazet@google.com,
	joabreu@synopsys.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	mcoquelin.stm32@gmail.com,
	minhuadotchen@gmail.com,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	peppe.cavallaro@st.com,
	simon.horman@corigine.com
Subject: Re: [PATCH v3] net: stmmac: compare p->des0 and p->des1 with __le32 type values
Date: Sat, 20 May 2023 09:55:27 +0800
Message-Id: <20230520015527.215952-1-minhuadotchen@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230519152715.7d1c3a49@kernel.org>
References: <20230519152715.7d1c3a49@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Jakub,

>On Fri, 19 May 2023 19:50:28 +0800 Min-Hua Chen wrote:
>> -		if ((p->des0 == 0xffffffff) && (p->des1 == 0xffffffff))
>> +		if (p->des0 == cpu_to_le32(0xffffffff) &&
>> +		    p->des1 == cpu_to_le32(0xffffffff))
>
>Can you try to fix the sparse tool instead? I believe it already
>ignores such errors for the constant of 0, maybe it can be taught 
>to ignore all "isomorphic" values?
>

I downloaded the source code of sparse and I'm afraid that I cannot make
0xFFFFFFFF ignored easily. I've tried ~0 instead of 0xFFFFFF,
but it did not work with current sparse.

0 is a special case mentioned in [1].

"""
One small note: the constant integer “0” is special. 
You can use a constant zero as a bitwise integer type without
sparse ever complaining. This is because “bitwise” (as the name
implies) was designed for making sure that bitwise types don’t
get mixed up (little-endian vs big-endian vs cpu-endian vs whatever),
and there the constant “0” really _is_ special.
"""

For 0xFFFFFFFF, it may look like a false alarm, but we can silence the
sparse warning by taking a fix like mine and people can keep working on
other sparse warnings easier.
(There are around 7000 sparse warning in ARCH=arm64 defconfig build and
sometimes it is hard to remember all the false alarm cases)

Could you consider taking this patch, please?

>
>By "isomorphic" I mean that 0xffffffff == cpu_to_le32(0xffffffff)
>so there's no point complaining.

thanks,
Min-Hua

[1] https://www.kernel.org/doc/html/v4.12/dev-tools/sparse.html

