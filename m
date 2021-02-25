Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB33325470
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 18:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233242AbhBYRPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 12:15:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232679AbhBYRPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 12:15:38 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA02AC06174A;
        Thu, 25 Feb 2021 09:14:57 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id n10so4199194pgl.10;
        Thu, 25 Feb 2021 09:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ptZSGNduCqA0B2NGqlCeIXaHGJ3fPPC3dn9cLh0I7ik=;
        b=G4fJAsJeWfC0GWoeHmYOrWgnNJgBFX4n2XNIpHlFU+vDhdvcG2r9MnKWm0Zo+J9YHP
         8Eiq1mCHQM6BnGYZkyO7DMW5sqyDb0uFXGn1epmUwM0xj9pmjtAlCqR87C0aqKdn8Bzj
         /4UFnNZcwCzVQrHd1YmRD3Ci+/YqTs83yQ4+TjV/OMWwgmIrECsp18sxLFBVT/2j2eKo
         bvhPI/GsFSEyTQ2dMYR2I3ZAc8tJXvVNgKjkmQT0/12BrVhHB240xfRk7yNEHLcMGi+l
         9ugdfZhdGmtMrfxhgA1HSTnu+MMdi3WCJvSTP9ArYfR06o83+DvBv8INo+G6EFCHaUJv
         QL+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ptZSGNduCqA0B2NGqlCeIXaHGJ3fPPC3dn9cLh0I7ik=;
        b=umiS5IgoZmQ3SxkSCYFPE8AtGhdljfv3T27K7d/huLvgUS7uPqnqqGD5EW/WoEw8PH
         Dzta25tpZsTAKCwGedv56/fIIHG3xQvTItonC7LCZvlc0ygXpnrWaxhoQwb7IlEajuES
         6fN2eVLhr6PrpNNVOa56U9ZJtG7lEDGzxRxseUOymtbRd3Xz+H+GXRt7AThLctf6azab
         2f3cT6WAl4bTfuzRkPjfpYMf3v6TTnBydqXdVyFKcYe462xbubjp9/TnRW6fW89lQu9y
         MKbzGKE5YEFmqtEDi+6TtC7vjjeE8EqBkUTP2IBZfG4h3Opt328FsLo65vTX95mAtVVa
         9b7g==
X-Gm-Message-State: AOAM5326ipWivQsIW0g7+7CS1ZiMzTmQjTVrU0JGsMDlSyJZZAkIRhn7
        u2+Gm7OdUqAnp5W4Xg2WEVc=
X-Google-Smtp-Source: ABdhPJyqsHOcMi4gNm4EvkknlyZr1OERkUkLw7+t0OXfCo2O7JbPogfykEWOwhV/S4DvJNyqbRb7Dg==
X-Received: by 2002:a63:a401:: with SMTP id c1mr3921545pgf.60.1614273297497;
        Thu, 25 Feb 2021 09:14:57 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id h123sm4755228pfe.115.2021.02.25.09.14.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 09:14:56 -0800 (PST)
Date:   Thu, 25 Feb 2021 09:14:54 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Heiko Thiery <heiko.thiery@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Fugang Duan <fugang.duan@nxp.com>
Subject: Re: [PATCH 1/1] net: fec: ptp: avoid register access when ipg clock
 is disabled
Message-ID: <20210225171454.GD17490@hoboy.vegasvil.org>
References: <20210220065654.25598-1-heiko.thiery@gmail.com>
 <20210222190051.40fdc3e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAEyMn7ZM7_pPor0S=dMGbmnp0hmZMrpquGqq4VNu-ixSPp+0UQ@mail.gmail.com>
 <20210223142726.GA4711@hoboy.vegasvil.org>
 <CAEyMn7Za9z9TUdhb8egf8mOFJyA3hgqX5fwLED8HDKw8Smyocg@mail.gmail.com>
 <20210223161136.GA5894@hoboy.vegasvil.org>
 <CAEyMn7YwvZD6T=oHp2AcmsA+R6Ho2SCYYkt2NcK8hZNUT7_TSQ@mail.gmail.com>
 <CAEyMn7Yjug3S=2mRC8uA=_+Tdxe=m6G-ga1YuupLSx3mPqUoug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEyMn7Yjug3S=2mRC8uA=_+Tdxe=m6G-ga1YuupLSx3mPqUoug@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 03:05:32PM +0100, Heiko Thiery wrote:

> But the explanation why it is currently disabled that way can be found
> in the commit 91c0d987a9788dcc5fe26baafd73bf9242b68900.

Okay, without re-factoring the entire driver, I agree that the gettime
lock up aught to be fixed in a similar way.  I missed the original
patch, but the diff fragment in this thread doesn't appear to take the
mutex as it should.

Thanks,
Richard
