Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420451F85CA
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 00:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgFMWyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jun 2020 18:54:18 -0400
Received: from smtp.uniroma2.it ([160.80.6.16]:42851 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbgFMWyR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Jun 2020 18:54:17 -0400
Received: from smtpauth-2019-1.uniroma2.it (smtpauth.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 05DMrxR4019350;
        Sun, 14 Jun 2020 00:54:04 +0200
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id 56E29120069;
        Sun, 14 Jun 2020 00:53:54 +0200 (CEST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1592088834; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/zs0CUi+Oz0j3LEZd44hCt+whNDO8jzzRMXHT/xwzzo=;
        b=+2tRaCtZyfIdpFZnhIrndpLvrS9HwWUL+4SKJaDpnV88xBZ1ekyo3yRw6iGPQ4TE94BWGa
        whgux0Qtuoe7yACg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1592088834; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/zs0CUi+Oz0j3LEZd44hCt+whNDO8jzzRMXHT/xwzzo=;
        b=ie30d2N771yY6UC4FH/KLpB+OZIKYdffd3BV3Bcv0bP+eLQTWYDcZwmUdkTF1aOhbtQqOH
        leoG4MKAfNO8EfWW5OlguXjY7cfm6bmm092PAeLrVzMXooGboKiIVZ5cA8C43MclHPGGqv
        aMuo/TZFSsX6vDT3gUpe1BR3dFVFqRS/Kexwbbhf+HBhCmNhLx6ycz7yTs6QQ7z9Ig4I5W
        7SDS/jMh5fziZzfwrj3zIoJDhD1URwY6GLH5W8+L6eTldmoDhvSRSRWx5XRQ+Vw9/fKQno
        4vlbAsYGoQEMYvSe92W1OlBZMd4SYhlpuf7m0rVR6XpPO7QFiSIvrxRjr05Szw==
Date:   Sun, 14 Jun 2020 00:53:53 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Donald Sharp <sharpd@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Dinesh Dutt <didutt@gmail.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: Re: [RFC,net-next, 2/5] vrf: track associations between VRF devices
 and tables
Message-Id: <20200614005353.fb4083bed70780feee2fd19a@uniroma2.it>
In-Reply-To: <20200613122859.4f5e2761@hermes.lan>
References: <20200612164937.5468-1-andrea.mayer@uniroma2.it>
        <20200612164937.5468-3-andrea.mayer@uniroma2.it>
        <20200613122859.4f5e2761@hermes.lan>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,
thanks for your questions.

On Sat, 13 Jun 2020 12:28:59 -0700
Stephen Hemminger <stephen@networkplumber.org> wrote:

> > +
> > +	 * Conversely, shared_table is decreased when a vrf is de-associated
> > +	 * from a table with exactly two associated vrfs.
> > +	 */
> > +	int shared_tables;
> 
> Should this be unsigned?
> Should it be a fixed size?

Yes. I think an u32 would be reasonable for the shared_table.
What do you think?

Andrea
