Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38DD28A420
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbgJJWzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:55:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30224 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731495AbgJJTaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 15:30:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602358219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w7stP7LFVG0hVv7TWg9unP2pHtrMNI2Rj9dU9V+EZSU=;
        b=M46zXXm84PYQ7fdksoumZs4d0wAeZHsklkunKhAn2W3CWKdS6pFTxdQqkZLBxWcTdIc52V
        0XUB+PShqshFdfNTVnPUdtYUzZGhwRoHc96ALMlfvbe4a6xhOCq+CSflsv8VAEyf3Cjh5B
        Q7Zpw60s9ujkL+kFcTSbLDve5Vfavwc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-nkhd_MdrPlKMVnMXaRClXw-1; Sat, 10 Oct 2020 06:44:12 -0400
X-MC-Unique: nkhd_MdrPlKMVnMXaRClXw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F5121868425;
        Sat, 10 Oct 2020 10:44:10 +0000 (UTC)
Received: from carbon (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 15B2E50B44;
        Sat, 10 Oct 2020 10:44:03 +0000 (UTC)
Date:   Sat, 10 Oct 2020 12:44:02 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        eyal.birger@gmail.com, brouer@redhat.com
Subject: Re: [PATCH bpf-next V3 0/6] bpf: New approach for BPF MTU handling
Message-ID: <20201010124402.606f2d37@carbon>
In-Reply-To: <20201009160010.4b299ac3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <160216609656.882446.16642490462568561112.stgit@firesoul>
        <20201009093319.6140b322@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <5f80ccca63d9_ed74208f8@john-XPS-13-9370.notmuch>
        <20201009160010.4b299ac3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Oct 2020 16:00:10 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> On Fri, 09 Oct 2020 13:49:14 -0700 John Fastabend wrote:
> > Jakub Kicinski wrote:  
> > > On Thu, 08 Oct 2020 16:08:57 +0200 Jesper Dangaard Brouer wrote:    
> > > > V3: Drop enforcement of MTU in net-core, leave it to drivers    
> > > 
> > > Sorry for being late to the discussion.
> > > 
> > > I absolutely disagree. We had cases in the past where HW would lock up
> > > if it was sent a frame with bad geometry.

I agree with Jakub here.  I do find it risky not to do these MTU check
in net-core.

> > > We will not be sprinkling validation checks across the drivers because
> > > some reconfiguration path may occasionally yield a bad packet, or it's
> > > hard to do something right with BPF.    
> > 
> > This is a driver bug then. As it stands today drivers may get hit with
> > skb with MTU greater than set MTU as best I can tell.  
> 
> You're talking about taking it from "maybe this can happen, but will
> still be at most jumbo" to "it's going to be very easy to trigger and
> length may be > MAX_U16".

It is interesting that a misbehaving BPF program can easily trigger this.
Next week, I will looking writing such a BPF-prog and then test it on
the hardware I have avail in my testlab.


> > Generally I expect drivers use MTU to configure RX buffers not sure
> > how it is going to be used on TX side? Any examples? I just poked
> > around through the driver source to see and seems to confirm its
> > primarily for RX side configuration with some drivers throwing the
> > event down to the firmware for something that I can't see in the code?  
> 
> Right, but that could just be because nobody expects to get over sized
> frames from the stack.
> 
> We actively encourage drivers to remove paranoid checks. It's really
> not going to be a great experience for driver authors where they need
> to consult a list of things they should and shouldn't check.
> 
> If we want to do this, the driver interface must most definitely say 
> MRU and not MTU.

What is MRU?

 
> > I'm not suggestiong sprinkling validation checks across the drivers.
> > I'm suggesting if the drivers hang we fix them.  
> 
> We both know the level of testing drivers get, it's unlikely this will
> be validated. It's packet of death waiting to happen. 
> 
> And all this for what? Saving 2 cycles on a branch that will almost
> never be taken?

I do think it is risky not to do this simple MTU check in net-core.  I
also believe the overhead is very very low.  Hint, I'm basically just
moving the MTU check from one place to another.  (And last patch in
patchset is an optimization that inlines and save cycles when doing
these kind of MTU checks).

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

