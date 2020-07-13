Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62CD521E353
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 00:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgGMW7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 18:59:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:33574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726442AbgGMW7I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 18:59:08 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE3112137B;
        Mon, 13 Jul 2020 22:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594681148;
        bh=rsL/H8CaK3e9rq5hy3RjgpfJ47NuhmsKidsXOEstw5k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Vh8CisEcxpqAUjy51vbrWa+A/uF4vNKs7iyj02wM5PnUn4FFqycxp5WHnWERig0I7
         URuN8xjYaUUs211KEvMQcKj3ATTggBWWrGlstk5odTPfE8GYkkRPATjimVddSVBoIx
         oHcsjAGILNl8IRdeIKUQCJ3f9u7SzxizEYwPgLN4=
Date:   Mon, 13 Jul 2020 15:59:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Boris Pismenny <borisp@mellanox.com>
Cc:     David Miller <davem@davemloft.net>, john.fastabend@gmail.com,
        daniel@iogearbox.net, tariqt@mellanox.com, netdev@vger.kernel.org
Subject: Re: [PATCH] tls: add zerocopy device sendpage
Message-ID: <20200713155906.097a6fcd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <9d13245f-4c0d-c377-fecf-c8f8d9eace2a@mellanox.com>
References: <1594550649-3097-1-git-send-email-borisp@mellanox.com>
        <20200712.153233.370000904740228888.davem@davemloft.net>
        <5aa3b1d7-ba99-546d-9440-2ffce28b1a11@mellanox.com>
        <20200713.120530.676426681031141505.davem@davemloft.net>
        <9d13245f-4c0d-c377-fecf-c8f8d9eace2a@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jul 2020 01:15:26 +0300 Boris Pismenny wrote:
> On 13/07/2020 22:05, David Miller wrote:
> > The TLS signatures are supposed to be even stronger than the protocol
> > checksum, and therefore we should send out valid ones rather than
> > incorrect ones.  
> 
> Right, but one is on packet payload, while the other is part of the payload.
> 
> > Why can't the device generate the correct TLS signature when
> > offloading?  Just like for the protocol checksum, the device should
> > load the payload into the device over DMA and make it's calculations
> > on that copy.  
> 
> Right. The problematic case is when some part of the record is already
> received by the other party, and then some (modified) data including
> the TLS authentication tag is re-transmitted.
> The modified tag is calculated over the new data, while the other party
> will use the already received old data, resulting in authentication error.
> 
> > For SW kTLS, we must copy.  Potentially sending out garbage signatures
> > in a packet cannot be an "option".  
> 
> Obviously, SW kTLS must encrypt the data into a different kernel buffer,
> which is the same as copying for that matter. TLS_DEVICE doesn't require this.

This proposal is one big attrition of requirements, which I personally
dislike quite a bit. Nothing material has changed since the first
version of the code was upstreamed, let's ask ourselves - why was the
knob not part of the initial submission?
