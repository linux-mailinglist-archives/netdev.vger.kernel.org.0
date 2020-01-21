Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E84B144739
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 23:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbgAUWYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 17:24:06 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39682 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728139AbgAUWYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 17:24:06 -0500
Received: by mail-pg1-f195.google.com with SMTP id 4so2283457pgd.6
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 14:24:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U7zoLTLkT4FRPpbHEk3PRh1Uf6zx0h1ZbdETeYpzu34=;
        b=TcBR/Nf2zex+WbZ+HvpriATJYWG4FdY9xDweikRmWGBtS4CZWv+47/bDt+CV5kKSi/
         7DSXjX6aud5eUmJw6QY+3Dz+Qzi3NTDKWBy4GnOBntx+OSzLgazoHkj8FkcERZvTUjuN
         /gppPWa1GyFKqoKWtsrQ/CvofmKJ55cLzTQOhDoWg0COxDk8WU3a7bBZzB8XRaN804mA
         Xrk+ned0WqoIQPjbhjULXTb1RCc8mhxES3BiKJf6FkfLafVEu/9soQBGmquOIoS82oWw
         dPcbta7hsRaIov7t9aoK82lteJRv8BmlPgw2njwJOUGQ/SzMHEyuyMIuZhbZ3blAnYjo
         OSaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U7zoLTLkT4FRPpbHEk3PRh1Uf6zx0h1ZbdETeYpzu34=;
        b=HKx2lL7GQ50lsIHhOy284o22UBwxgknRRN2R91DIkhPQUTNVa7Zl7tbqU51VTsTmW6
         /rFdp8S0pIBT5nt9KAlGMhzcB4SFaN2kk6Sym2KBoU+8XLm0NEWbjQk63FprWsEJ7xn8
         VhnKXg3LW9YZAISE/tvsRJ/g58555i0qal54IYlqja1jviaWT1bNMV2UMMP6lxhI/VX/
         /NHzak/IjDoAkkh1GGvSnSAufFw5OiQ7M/G+7vkLsLtPkJISa4QxG2tx7Bg0Xz/WCLyO
         hBesBVNzWTQVOiKlVhKviBaHgAbtfXyDN6wxk80mXU8Thyu5lelaJNNrARmJgOxurF4A
         JbkA==
X-Gm-Message-State: APjAAAVuVE9DRvprdHUS1idFZlmJUkDWHIaFdDMUn9hAmdmVlljHVMRp
        BiciKFciaPB+oyC5kcxir1JJGw==
X-Google-Smtp-Source: APXvYqxFARC+hUQHitMqA8VCva1q6WgoKntCtzw9K72ZO50v/in7d0ZjkWBpU9yQP9sxdOqMI0i58w==
X-Received: by 2002:a63:5243:: with SMTP id s3mr7416825pgl.449.1579645445908;
        Tue, 21 Jan 2020 14:24:05 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id u128sm44956335pfu.60.2020.01.21.14.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 14:24:05 -0800 (PST)
Date:   Tue, 21 Jan 2020 14:23:56 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Finn Thain <fthain@telegraphics.com.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Chris Zankel <chris@zankel.net>,
        Laurent Vivier <laurent@vivier.eu>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 05/12] net/sonic: Fix receive buffer handling
Message-ID: <20200121142356.2b17ad74@hermes.lan>
In-Reply-To: <e20133bf43ec6f5967a3330dacaf38f653bf3061.1579641728.git.fthain@telegraphics.com.au>
References: <cover.1579641728.git.fthain@telegraphics.com.au>
        <e20133bf43ec6f5967a3330dacaf38f653bf3061.1579641728.git.fthain@telegraphics.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Jan 2020 08:22:08 +1100
Finn Thain <fthain@telegraphics.com.au> wrote:

>  
> +/* Return the array index corresponding to a given Receive Buffer pointer. */
> +
> +static inline int index_from_addr(struct sonic_local *lp, dma_addr_t addr,
> +				  unsigned int last)

Why the blank line between comment and the start of the function?

Also, the kernel standard is not to use the inline keyword on functions
and let the compiler decide to inline if it wants to. The compiler is much
smarter at knowing the architectural limitations than humans are.
