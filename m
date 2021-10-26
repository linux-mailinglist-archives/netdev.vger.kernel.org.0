Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D2143B263
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 14:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235237AbhJZMaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 08:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbhJZMaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 08:30:07 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3DF7C061745
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 05:27:43 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id i14so1178188ioa.13
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 05:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=forshee.me; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=V+t8Uh427gXOwBLEDrEt+gH2ARCwSbvbPoEeeptk2yo=;
        b=eNy9xO6KA1OgHa5Ht2c1KSa5vPFfwYaNhksbiRtYrOw+PwQ5PID0vjiuNkhuIfuVLh
         cPXX+BXnCxHsvg521P+x0WiIx1Bi2MTmafO9/zZBLwUOZvPzGgh9eiDo4F6UrJthVbV1
         ILToS25sji6o1gU3GqgtSJyPc1OPB+rLLOmExy5HsQga2bA1kIo8q9eakPcjTYEF7U1z
         l+kNWPEtfkaMxxx32CO89vjRfMl2lDTujiKr1MBOWVpNCYytbzeRHbtRSQ1Ab9eTYUGe
         KGyG6xsAP35lePhAnyfp/L6Yj+AVk+pKQDkbC58tuRJO6ei8NE/qZEbw6FpgActzfmwU
         B7wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V+t8Uh427gXOwBLEDrEt+gH2ARCwSbvbPoEeeptk2yo=;
        b=fXQjmCuV3k4p9T0aTORRDlTEZavAB2e5ocwYyIEDjO//xnqrGoE8X2VnSo8atwxurX
         Xlf6HHk5iX+usgZ8Dlkinh/3vuvzRV9LsnH900F2JHVxj7EDNmDHxpRsFVIgH2VJWNLK
         jqTTPWcvC2wFBw0VrjUWzD1kX7TBh57PXtkAFHNm2BN6iLzoTyFPjai/F2eoi5mYOWlu
         vruFx1zVgfUmGmA5+SnGrFtdFthn7/+GVPHU3mp0JappBrDIJmq3idbbqmwqrVnRraau
         zNpqIhrdieG0nUs7w2SKMTqMU52cmvlzQbXlAVLPZmDf1QuaymnBvFHuH3Etn0dn+CGT
         lyFQ==
X-Gm-Message-State: AOAM533InOQyhAeFOGuAAkJRF8/7hPxFfd4hHD8ISkxNDdQ+y45+nYZE
        k883Go8l3rVzptwcfe+rU4+bvw==
X-Google-Smtp-Source: ABdhPJyWjOeRB0XmPfxyDLYYs5rCcDrDGehWGq8z2FIkNvTN4WvYfL1BNzJmNXSLTVPTDjQqtcDoUw==
X-Received: by 2002:a02:5409:: with SMTP id t9mr7620884jaa.43.1635251263393;
        Tue, 26 Oct 2021 05:27:43 -0700 (PDT)
Received: from localhost ([2605:a601:ac0f:820:fca3:95d3:b064:21ae])
        by smtp.gmail.com with ESMTPSA id t2sm5770986ilg.1.2021.10.26.05.27.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 05:27:42 -0700 (PDT)
Date:   Tue, 26 Oct 2021 07:27:42 -0500
From:   Seth Forshee <seth@forshee.me>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Paul E. McKenney" <paulmck@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sch: eliminate unnecessary RCU waits in
 mini_qdisc_pair_swap()
Message-ID: <YXf0PpSPNu31pXDM@ubuntu-x1>
References: <20211022161747.81609-1-seth@forshee.me>
 <20211025124828.1e4900e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211025124828.1e4900e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 25, 2021 at 12:48:28PM -0700, Jakub Kicinski wrote:
> On Fri, 22 Oct 2021 11:17:46 -0500 Seth Forshee wrote:
> > From: Seth Forshee <sforshee@digitalocean.com>
> > 
> > Currently rcu_barrier() is used to ensure that no readers of the
> > inactive mini_Qdisc buffer remain before it is reused. This waits for
> > any pending RCU callbacks to complete, when all that is actually
> > required is to wait for one RCU grace period to elapse after the buffer
> > was made inactive. This means that using rcu_barrier() may result in
> > unnecessary waits.
> > 
> > To improve this, store the current RCU state when a buffer is made
> > inactive and use poll_state_synchronize_rcu() to check whether a full
> > grace period has elapsed before reusing it. If a full grace period has
> > not elapsed, wait for a grace period to elapse, and in the non-RT case
> > use synchronize_rcu_expedited() to hasten it.
> > 
> > Since this approach eliminates the RCU callback it is no longer
> > necessary to synchronize_rcu() in the tp_head==NULL case. However, the
> > RCU state should still be saved for the previously active buffer.
> > 
> > Before this change I would typically see mini_qdisc_pair_swap() take
> > tens of milliseconds to complete. After this change it typcially
> > finishes in less than 1 ms, and often it takes just a few microseconds.
> > 
> > Thanks to Paul for walking me through the options for improving this.
> > 
> > Cc: "Paul E. McKenney" <paulmck@kernel.org>
> > Signed-off-by: Seth Forshee <sforshee@digitalocean.com>
> 
> LGTM, but please rebase and retest on top of latest net-next.

Will do.

> >  void mini_qdisc_pair_swap(struct mini_Qdisc_pair *miniqp,
> >  			  struct tcf_proto *tp_head)
> >  {
> > @@ -1423,28 +1419,30 @@ void mini_qdisc_pair_swap(struct mini_Qdisc_pair *miniqp,
> >  
> >  	if (!tp_head) {
> >  		RCU_INIT_POINTER(*miniqp->p_miniq, NULL);
> > -		/* Wait for flying RCU callback before it is freed. */
> > -		rcu_barrier();
> > -		return;
> > -	}
> > +	} else {
> > +		miniq = !miniq_old || miniq_old == &miniqp->miniq2 ?
> > +			&miniqp->miniq1 : &miniqp->miniq2;
> >  
> > -	miniq = !miniq_old || miniq_old == &miniqp->miniq2 ?
> > -		&miniqp->miniq1 : &miniqp->miniq2;
> 
> nit: any reason this doesn't read:
> 
> 	miniq = miniq_old != &miniqp->miniq1 ? 
> 		&miniqp->miniq1 : &miniqp->miniq2;
> 
> Surely it's not equal to miniq1 or miniq2 if it's NULL.

I agree, that looks simpler and functionally equivalent. It seems
off-topic for this patch though; I'm only touching that line to change
the indentation.

Thanks,
Seth
