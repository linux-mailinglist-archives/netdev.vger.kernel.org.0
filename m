Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34A6B4DBB1D
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 00:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345175AbiCPXgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 19:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232408AbiCPXgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 19:36:07 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CAD2167DF;
        Wed, 16 Mar 2022 16:34:52 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id ja24so1958841ejc.11;
        Wed, 16 Mar 2022 16:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ARERQSDKxTIHCnmFYNI1ElJI4Oo2Aq2UKhPNaAbSNg4=;
        b=Sg3427dW092vAOLJR2XEcQ/K29NB/DZt5twKJ8gVmA9TrPScdCEOtwyPlsi4FCZsiQ
         bN6oZmE9p4etd9Y6inAr5Puw1utDZX1rFnBWQ/Kpw1SJwyJvdV92GzUsabqabxxpvrUw
         SuzDuuIWz9zSPEAhmuwzs5F3vzZwI94orfMmhn15cY4No379IIbQ/JRjSzJKRW3gtKKD
         rxnRnwNQyJvEIEh4HtC9XgiNZGXrJ4PnKGxAYhTfEkNyZz1Hr0L41eJNWrJGUv7Avdcz
         DmvCS0goyAE/O66WKrs1t7lWQet5Au9SV2XSJTjXfMpLlMmnET6Qdd40ZCIJXPmUKBRG
         Fj5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ARERQSDKxTIHCnmFYNI1ElJI4Oo2Aq2UKhPNaAbSNg4=;
        b=xYAT4y0G75ohW22UICSAs5bWNIe9pFlR27c19Qs/ibS/r6TDfGlwEaxIiqKNszVl8z
         dVXsjJpDnTPsP+BWH1/AA+exNUMUPjzaKdxL4cHnpeuO7xKAJ93KbzMHZfJtybAsdXU9
         kB8IYI8b/gtRXpywn1ve+lYHQtn24PCTVKooSSpHoIvv4j06HKEBM6oaRk/q1AH3tnTq
         IlFYShQnGoThH/LT8kppB2AKGnv1iuSXH/0s+C/nxgsiT8hd+b+YF66gVIiTyYaK1Uaz
         c91kyauEW1WBbDqy1FeBVMsmYULaHAEy8ReZpb5VcyXB6OhifRRzOiknCMuAQP8zFdW4
         /gFQ==
X-Gm-Message-State: AOAM531bg0w0LvVl8OWZNsT9xvjJOtECzblHIPeYo/8ECg2athyDyLzP
        x0KmHUDxPEFUPipWfCCpLpw=
X-Google-Smtp-Source: ABdhPJwzQis6t91nexEui4K1KPa23MRwnqFeO4w44T/uxSjtpflFDPZt8DNsrj9ZuyA0q7D5SMSOpQ==
X-Received: by 2002:a17:906:a398:b0:6ce:71b:deff with SMTP id k24-20020a170906a39800b006ce071bdeffmr1962568ejz.204.1647473690310;
        Wed, 16 Mar 2022 16:34:50 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id l9-20020a170906078900b006dac5f336f8sm1505354ejc.124.2022.03.16.16.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 16:34:49 -0700 (PDT)
Date:   Thu, 17 Mar 2022 01:34:47 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 3/3] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
Message-ID: <20220316233447.kwyirxckgancdqmh@skbuf>
References: <20220310142320.611738-1-schultz.hans+netdev@gmail.com>
 <20220310142320.611738-4-schultz.hans+netdev@gmail.com>
 <20220310142836.m5onuelv4jej5gvs@skbuf>
 <86r17495gk.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86r17495gk.fsf@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 14, 2022 at 11:46:51AM +0100, Hans Schultz wrote:
> >> @@ -396,6 +414,13 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
> >>  				    "ATU miss violation for %pM portvec %x spid %d\n",
> >>  				    entry.mac, entry.portvec, spid);
> >>  		chip->ports[spid].atu_miss_violation++;
> >> +		if (mv88e6xxx_port_is_locked(chip, chip->ports[spid].port))
> >> +			err = mv88e6xxx_switchdev_handle_atu_miss_violation(chip,
> >> +									    chip->ports[spid].port,
> >> +									    &entry,
> >> +									    fid);
> >
> > Do we want to suppress the ATU miss violation warnings if we're going to
> > notify the bridge, or is it better to keep them for some reason?
> > My logic is that they're part of normal operation, so suppressing makes
> > sense.
> >
> 
> I have been seeing many ATU member violations after the miss violation is
> handled (using ping), and I think it could be considered to suppress the ATU member
> violations interrupts by setting the IgnoreWrongData bit for the
> port (sect 4.4.7). This would be something to do whenever a port is set in locked mode?

So the first packet with a given MAC SA triggers an ATU miss violation
interrupt.

You program that MAC SA into the ATU with a destination port mask of all
zeroes. This suppresses further ATU miss interrupts for this MAC SA, but
now generates ATU member violations, because the MAC SA _is_ present in
the ATU, but not towards the expected port (in fact, towards _no_ port).

Especially if user space decides it doesn't want to authorize this MAC
SA, it really becomes a problem because this is now a vector for denial
of service, with every packet triggering an ATU member violation
interrupt.

So your suggestion is to set the IgnoreWrongData bit on locked ports,
and this will suppress the actual member violation interrupts for
traffic coming from these ports.

So if the user decides to unplug a previously authorized printer from
switch port 1 and move it to port 2, how is this handled? If there isn't
a mechanism in place to delete the locked FDB entry when the printer
goes away, then by setting IgnoreWrongData you're effectively also
suppressing migration notifications.

Oh, btw, my question was: could you consider suppressing the _prints_ on
an ATU miss violation on a locked port?
