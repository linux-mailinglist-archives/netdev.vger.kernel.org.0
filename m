Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 247633A7B61
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 12:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbhFOKGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 06:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbhFOKGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 06:06:39 -0400
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB5FC061574
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 03:04:34 -0700 (PDT)
Received: from miraculix.mork.no ([IPv6:2a02:2121:346:c551:fc26:65ff:feae:d816])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 15FA4Mct021729
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Tue, 15 Jun 2021 12:04:23 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1623751463; bh=Q4K+AYa9BL6Q7woN2FCseiWtJUiKj/PFCm8APfPBwQo=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=HIaWC4VdA2GvQwLZ4Z9fiC2iWSKYzw9ZAwzA0JSOyLC8vnEcvCEZ80eqC/ckrFxzP
         bb8Yt6oQ5YAz/Afs+w1mphiSdwGjQ/CXd7cjGk+VTE/N4rP93Ya8jsZiumjmR2uSlj
         4ygHnmlfi7XyvijhpZ4nbfkuN+XHVGKnPDTW4DRc=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94.2)
        (envelope-from <bjorn@mork.no>)
        id 1lt5vi-000YwU-4T; Tue, 15 Jun 2021 12:04:22 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Kristian Evensen <kristian.evensen@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        subashab@codeaurora.org
Subject: Re: [PATCH net] qmi_wwan: Clone the skb when in pass-through mode
Organization: m
References: <20210614141849.3587683-1-kristian.evensen@gmail.com>
        <8735tky064.fsf@miraculix.mork.no>
        <20210614130530.7a422f27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAKfDRXgQLvTpeowOe=17xLqYbVRcem9N2anJRSjMcQm6=OnH1A@mail.gmail.com>
Date:   Tue, 15 Jun 2021 12:04:21 +0200
In-Reply-To: <CAKfDRXgQLvTpeowOe=17xLqYbVRcem9N2anJRSjMcQm6=OnH1A@mail.gmail.com>
        (Kristian Evensen's message of "Tue, 15 Jun 2021 11:03:24 +0200")
Message-ID: <877divwije.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.4 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kristian Evensen <kristian.evensen@gmail.com> writes:

>> It does look pretty strange that qmimux_rx_fixup() copies out all
>> packets and receives them, and then let's usbnet to process the
>> multi-frame skb without even fulling off the qmimux_hdr. I'm probably
>> missing something.. otherwise sth like FLAG_MULTI_PACKET may be in
>> order?
>
> qmimux_rx_fixup() is different from what we are discussing here.
> qmimux_rx_fixup() is used when the de-aggregation is performed by the
> qmi_wwan driver, while the passthrough flag is set when the
> de-aggregation is done by the rmnet driver. The logic in
> qmimux_rx_fixup() is very similar to how the other usbnet mini-drivers
> handles de-aggregation and also how de-aggregation is handled by for
> example rmnet. I have no opinion on if the logic makes sens or not,
> but at least the origin can be traced :)

Yes, FLAG_MULTI_PACKET is only applicable to the qmimux case. But I
think Jakub is right that we should set it anyway. There is no way to
return from rx_fixup without an error or further processing of the skb,
unless we set FLAG_MULTI_PACKET.  Or invent something else.  But setting
that flag and then add the necessary usnet_sb_return call doesn't look
too bad?



Bj=C3=B8rn
