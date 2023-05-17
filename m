Return-Path: <netdev+bounces-3403-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 79A25706EBE
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 18:53:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6DC031C20F91
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 16:53:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF03D209BE;
	Wed, 17 May 2023 16:53:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31BE111B5
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 16:53:40 +0000 (UTC)
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C989D
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 09:53:39 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-966287b0f72so179527166b.0
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 09:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684342417; x=1686934417;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TOoUMKGS/ra1q+XSjrgibDITMni+gNWwNRNml9HVdz8=;
        b=NuZEC1+gjw9v/sxxRZfaXtyIZSr+K2lwjeafhZcRd45GepeWLalpe0xK9aBhSat6BZ
         CdrRMgwrzlEbBTzYaYCBWA7eKCw25Q0cylxhU1bkZDOMt8LPYgkvEfJKSfHjwQqRoybO
         C36cbsqVytWJNZGWW3DMTBgWvL69m599l+g6cbKhycVFh9m5RYh9VInUwTWl7Mh2AyhU
         nOGhKrOakYtkzXWkWr+4Xt/qFfWuAWbl1XhRfF/l01TMkFSCA7d8pNl+BL7fpGk3R4sU
         YezuefNsucKC0MwrnPGvs0mU4Mk+eUnty7bNnHLPrdg+VYySb1AHropyziDXgriX86/W
         iiGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684342417; x=1686934417;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TOoUMKGS/ra1q+XSjrgibDITMni+gNWwNRNml9HVdz8=;
        b=AdB91O/10oqfNqbBR//i9vZAIJGEGRYA9m75cNuO0aYToVIWQHheoHQhDvLkCt52QN
         d7YpuAumC/ukU1SYtStpSmrA/j0paD/w9fcu/Cd0CdVLvE6r0MqRQEvwy4vHA5YZgE4S
         29lyjjM8GlJH2CsLCDh7vDC799IhNTcP/qA3csiV69ABxHEx52oGts2ixGito7HdUZEE
         e+ezcXTtRXZAM+C1by52JcLx2IdN68H40/RXBI9pPqBCL6ggmDrNAhX/ompujppDli5A
         5tQf9ZC049v7qQlcmYh2j/v8+q9aJPTOANZ9Rq/qRISBTGNjriFZ5/2m04/UPtNakeUZ
         SJCA==
X-Gm-Message-State: AC+VfDydY/4RaOVHbfUB4cli9BR+UO3QH0wAxMwtHLChDyblE4SenPer
	3klcedZozG9dx1x9j6fuhLs=
X-Google-Smtp-Source: ACHHUZ4QiGCK7cKLkYhMV7LDrzY64kTDU9UWAG0HjCrdP07APwUpb020ZMfltDOWmMOH/K5vX73luQ==
X-Received: by 2002:a17:907:74c:b0:953:37eb:7727 with SMTP id xc12-20020a170907074c00b0095337eb7727mr41652845ejb.43.1684342417426;
        Wed, 17 May 2023 09:53:37 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id hg8-20020a1709072cc800b00932fa67b48fsm12466088ejc.183.2023.05.17.09.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 09:53:37 -0700 (PDT)
Date: Wed, 17 May 2023 19:53:35 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: Tobias Waldekranz <tobias@waldekranz.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Fabio Estevam <festevam@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Steffen =?utf-8?B?QsOkdHo=?= <steffen@innosonix.de>,
	netdev <netdev@vger.kernel.org>
Subject: Re: mv88e6320: Failed to forward PTP multicast
Message-ID: <20230517165335.o2hvnz7ymi3nh7sy@skbuf>
References: <CAOMZO5AMOVAZe+w3FiRO-9U98Foba5Oy4f_C0K7bGNxHA1qz_w@mail.gmail.com>
 <7b8243a3-9976-484c-a0d0-d4f3debbe979@lunn.ch>
 <CAOMZO5DXH1wS9YYPWXYr-TvM+9Tj8F0bY0_kd_EAjrcCpEJJ7A@mail.gmail.com>
 <CAOMZO5Dk44QSTg2rh_HPHXg=H7BJ+x1h95M+t8nr2CLW+8pABw@mail.gmail.com>
 <5e21a8da-b31f-4ec8-8b46-099af5a8b8af@lunn.ch>
 <CAOMZO5DSSQY5fa5vTmDbCxu1x2ZRdyB2kTqrkw5bRg94_-34zg@mail.gmail.com>
 <87pm77dg5i.fsf@waldekranz.com>
 <CAOMZO5CZoy12WrBEQFMupv5sPh2EjSPm+UmGz=-WkS7A97CtqQ@mail.gmail.com>
 <87wn1foze1.fsf@waldekranz.com>
 <CAOMZO5AQtL1BNk2sm2v=c5fLbukkZSi6HSJXexp4QB4JjAyw-g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOMZO5AQtL1BNk2sm2v=c5fLbukkZSi6HSJXexp4QB4JjAyw-g@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 03:10:00PM -0300, Fabio Estevam wrote:
> Hi Tobias,
> 
> On Thu, May 11, 2023 at 8:56 AM Tobias Waldekranz <tobias@waldekranz.com> wrote:
> 
> > I imagine that if you were to open a socket and add a membership to the
> > group, the packets would reach the CPU. What happens if you run:
> >
> > socat udp-recvfrom:1234,ip-add-membership=224.0.1.129:br0 gopen:/dev/null &
> >
> > Can you see the PTP packets on the CPU now?
> 
> Yes, this seems to do the trick!
> 
> After adding a membership to the group, I don't see the PTP traffic
> getting blocked anymore on a VLAN-aware configuration.
> 
> I will be running more tests, but this seems to be very promising.

Slightly unrelated to the original topic and probably completely
unrelated to Fabio's actual issue.

I'm completely inapt when it comes to IP multicast. Tobias, does the
fact that br0 have mcast_router 1 mean that the CPU port should be a
recipient of all multicast traffic, registered or unregistered?

