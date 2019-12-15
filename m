Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4940311F52D
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 01:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfLOA3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 19:29:17 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46607 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726783AbfLOA3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 19:29:16 -0500
Received: by mail-pg1-f194.google.com with SMTP id z124so1491444pgb.13
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 16:29:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=wmVt/esTKXdnuPAuAKVkzDF8McEsa/4PpSxyCcerGEo=;
        b=FSDNitvgo+gPiPyQqHK2JUU24JkNwojpjt8ezUJ+fELtcCnQpp/kTvBG+ko5IycxDj
         44Ve9q3hmX7ijkge+x8FX2YW6TyvfyS+zpKCBg0EnvQCUpu+iIQfWa7xQFcKEAc+dPPB
         hmcy5qzY/crvuzVtIYHO8eaLpnxNqP2T8MkjNVqjjIuEovTcNOp5GXV28RRG9ZFKtMch
         lO23ionfeyrUAIt1yPdmygiDXSqKums8Py/lcopnk6P3EFR3rwA97XHgWkSxZiCdBNoe
         EWufK2K+vvc/uUVCvzMA2eNGtAdr3oFVHqohZRs2lhl2IENMr9+1H7wxueHqDOJr4UZy
         CT1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=wmVt/esTKXdnuPAuAKVkzDF8McEsa/4PpSxyCcerGEo=;
        b=JA7AWE3eijpwdJ5p0uko8z7Esye6kPvbqxYmShggpIz2rHi89mlxVI2isyjD1R0UMG
         gp1w7DkmCUpofwJV+3AgUBnJf65aEEa3M675RBg48eCIj96JoizvPglCgLJW9qAP5GHO
         hc959/9xzbEuDCyf+iXcPUj68IkA4pcg+s3Quo33W2r75CwSAPCeyvJK43q9z8iAuy36
         Lismhg/XCa9UzJcvDhwrrAg3zT+oSOH8THxtyLpsIcvOtFXAcHjOfZip10uZxqWnyhwi
         g3tqv8946iYqdIZ2GydZftLRIBaRJvhj4WvL2gQY1Ybluu5P7JRL5YYhxfiiSCuzodgs
         18mg==
X-Gm-Message-State: APjAAAVVQw12AZkHt4uOoF4KTbmnbUU/G1Gle2wVzvNqt47aWNMb7Hon
        DJ51kHEuGJZK8eMjv5zYJX5YDA==
X-Google-Smtp-Source: APXvYqzzjFIFeEOvE+qTD47kQzLuAB31A3879i8QC/8HP8XPyBeW7CkgizYG1N2je7paRTofZOmV0w==
X-Received: by 2002:a65:644b:: with SMTP id s11mr8934421pgv.332.1576369756202;
        Sat, 14 Dec 2019 16:29:16 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id v1sm11313664pjy.9.2019.12.14.16.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2019 16:29:16 -0800 (PST)
Date:   Sat, 14 Dec 2019 16:29:12 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>, Andy Gospodarek <andy@greyhouse.net>,
        Veaceslav Falico <vfalico@gmail.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Mahesh Bandewar <mahesh@bandewar.net>
Subject: Re: [PATCH net] bonding: fix active-backup transition after link
 failure
Message-ID: <20191214162912.41936ef1@cakuba.netronome.com>
In-Reply-To: <26868.1576268917@famine>
References: <20191206234455.213159-1-maheshb@google.com>
        <10902.1575756592@famine>
        <CAF2d9jgjeky0eMgwFZKHO_RLTBNstH1gCq4hn1FfO=TtrMP1ow@mail.gmail.com>
        <26918.1576132686@famine>
        <CAF2d9jh7WAydcm79VYZLb=A=fXo7B7RDiMquZRJdP2fnwnLabg@mail.gmail.com>
        <26868.1576268917@famine>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Dec 2019 12:28:37 -0800, Jay Vosburgh wrote:
> 	Ok, I think I understand, and am fine with the patch as-is.
> 
> Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

Okay, applied then, and queued for 4.14+ stable.

Mahesh, I reworded the commit message slightly, checkpatch insists
that the word "commit" occurs before the hash when quoting.

Thanks!
