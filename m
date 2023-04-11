Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7ABD6DE172
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 18:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbjDKQtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 12:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbjDKQte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 12:49:34 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3311723
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 09:49:32 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id jx2-20020a17090b46c200b002469a9ff94aso6794941pjb.3
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 09:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112; t=1681231771; x=1683823771;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DzUgLVBZ5LliSIbWRb8w3V1qKjkO4SU09T7F7NrrZD8=;
        b=DbP+PKv3F6PUg1HCFsCmNGjEtFZtFFHhu+qWX3v7yN7x0bpP4tsq2ePql1UNz0YK3F
         uEZFnyNc9OnSDw/70Qqgc8FOf2RVk/y1V6BZQYbrUSeY/64M156qCM2hIjnGguC7/PTy
         6/tWlZL7+TtXB7LlLHrvUPHrM1sEu3H3vfF8k+gZ9CywmIq++vnwxAREoZ75oZ9TnJi2
         fZo1WUOwxWSOPxDbhqzuTDijQuQDWlfO9fQKw0DOvTIC6oUD75n1UJJmiQ49Fusm5l5l
         ityYEywMCwbQkjsqLhp95hfd4Z0r1jhSYh4QcEE4z0feqk3PNPdZxqXPtImz2G4or1ml
         uXfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681231771; x=1683823771;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DzUgLVBZ5LliSIbWRb8w3V1qKjkO4SU09T7F7NrrZD8=;
        b=QfdWMFUBjxXrIVG/2TCkFDxYlOnvNGeNHltZayV8o04wIH2Vfm4J37XpRyb6yIoVUd
         LV/W/lDqxacJjQfNIRs88JqlV5znlXzZA4o9v86EtUUzamsI6EJjSozLCX85T1Y4EQ0K
         ws+DtaAnsatnfp2Y9CNofE3C0Z310hk3UY8tW6SG04+FQCuP2P7GPDm/ejRNVGUHRVyL
         uwgixMchrjfFePKyuzPBqH4w9j1TJVUS92Yud/CvCYQ1p1mFc7b1xkLRXzE7dIJpZZ3U
         q5BuKDhzAb2JK3FTy7sZTaep85jc9wE5VdJzVgHDRuoVkay6rPsS/yaXYzE1QzzBMmc+
         HnHA==
X-Gm-Message-State: AAQBX9c9licK/ZaHetEFQ1IUVhKpu7ex/YXndbDK1E5NhFZIw0KVyrrl
        F8ChQhSZcR8sXOTTJ9ay6GT2F76UtnZ4sSTF+Du3o0QN
X-Google-Smtp-Source: AKy350ZoSRnTitJCuYc/TIIWoyASLfaKrZBpqjwckQi5vqCUvI1Hz+6AH6yQR9tmmtzojT/mzvUWkA==
X-Received: by 2002:a17:902:ce8e:b0:1a2:56f4:d369 with SMTP id f14-20020a170902ce8e00b001a256f4d369mr18946638plg.19.1681231771513;
        Tue, 11 Apr 2023 09:49:31 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id iz4-20020a170902ef8400b00195f0fb0c18sm8209853plb.31.2023.04.11.09.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 09:49:31 -0700 (PDT)
Date:   Tue, 11 Apr 2023 09:49:29 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, bluca@debian.org, Robin <imer@imer.cc>
Subject: Re: [PATCH iproute2] iptunnel: detect protocol mismatch on tunnel
 change
Message-ID: <20230411094929.5d80ef23@hermes.local>
In-Reply-To: <ac05b04d-a7ad-3804-39fd-2267904e9f23@kernel.org>
References: <20230410233509.7616-1-stephen@networkplumber.org>
        <ac05b04d-a7ad-3804-39fd-2267904e9f23@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Apr 2023 09:55:25 -0600
David Ahern <dsahern@kernel.org> wrote:

> That addresses the stack smashing, but ....
> 
> >  
> >  				if (tnl_get_ioctl(*argv, &old_p))
> >  					return -1;
> > -				*p = old_p;
> > +
> > +				if (old_p.ip_tnl.iph.version != 4 ||
> > +				    old_p.ip_tnl.iph.ihl != 5)  
> 
> this field overlays laddr in ip6_tnl_parm2 which means there is a
> collision in valid addresses.

That is why the commit message said this is best effort.
What happens when there is a collision with a valid address is that
the call will fail later as a bogus change to an IP6 tunnel.

 # ip tunnel add gre1 mode ip6gre local 4545:db8::1 remote 2001:db8::2 ttl 255
 # ip tunnel change gre1 mode gre local 192.168.0.0 remote 192.168.0.1 ttl 255
ttl != 0 and nopmtudisc are incompatible

This is off in the non-standard IPv6 address range so not a likely
to bother anyone.
