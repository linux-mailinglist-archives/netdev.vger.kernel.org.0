Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA173454F4
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 02:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbhCWBYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 21:24:23 -0400
Received: from p3plsmtpa11-09.prod.phx3.secureserver.net ([68.178.252.110]:53997
        "EHLO p3plsmtpa11-09.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230317AbhCWBXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 21:23:52 -0400
Received: from chrisHP110 ([76.103.216.188])
        by :SMTPAUTH: with ESMTPA
        id OVlulYCVtysOoOVlul5DiR; Mon, 22 Mar 2021 18:23:51 -0700
X-CMAE-Analysis: v=2.4 cv=Q50XX66a c=1 sm=1 tr=0 ts=60594327
 a=ZkbE6z54K4jjswx6VoHRvg==:117 a=ZkbE6z54K4jjswx6VoHRvg==:17
 a=kj9zAlcOel0A:10 a=SKD8Yt_7dumfzhw-_5gA:9 a=CjuIK1q_8ugA:10
X-SECURESERVER-ACCT: don@thebollingers.org
From:   "Don Bollinger" <don@thebollingers.org>
To:     "'Andrew Lunn'" <andrew@lunn.ch>
Cc:     "'Moshe Shemesh'" <moshe@nvidia.com>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'Adrian Pop'" <pop.adrian61@gmail.com>,
        "'Michal Kubecek'" <mkubecek@suse.cz>, <netdev@vger.kernel.org>,
        "'Vladyslav Tarasiuk'" <vladyslavt@nvidia.com>,
        <don@thebollingers.org>
References: <1616433075-27051-1-git-send-email-moshe@nvidia.com> <1616433075-27051-2-git-send-email-moshe@nvidia.com> <006801d71f47$a61f09b0$f25d1d10$@thebollingers.org> <YFk13y19yMC0rr04@lunn.ch>
In-Reply-To: <YFk13y19yMC0rr04@lunn.ch>
Subject: RE: [RFC PATCH V4 net-next 1/5] ethtool: Allow network drivers to dump arbitrary EEPROM data
Date:   Mon, 22 Mar 2021 18:23:49 -0700
Message-ID: <007b01d71f83$2e0538f0$8a0faad0$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQJDEuFgm6Tcdwd/2H9v4w1v+xnhXwGLU1CXAWGs15oCOWnrmqmPqhwQ
Content-Language: en-us
X-CMAE-Envelope: MS4xfI5/9Qsv/Nn5zPUgNeKpwySIiXNjS3IfOhadcs7eSfRdnksIQaG+MG+tePIS4Gj3zlxPTEVv+qqtDE44ZVWtC3Lf+YWeYSuqTiRAipidZTya0nURT4cM
 cszz+kZTKVDRmCmFDuNVcppaX9I0x8ugJTtKNZMLqXvOQfM00SZNhvuNVzSTZHIAvYxiC3JUeNONHqcCNHQ93+YQwhU/gBZFU8fmb3xouAhL5+7c07ZdPP/B
 9WonUv6YkbYscSmv4yZOWACenX3dUqNrcmB9WaCSRVfsCjLHBQqHn9fUYwS04NJwgfaRpxIkVnvszp5Jsd9cssEkkg/2mPqikiqVaWTHbVO3cs2ZSfd3CxrC
 83yzA4GJYH93+I72O7FoVE+ZjapQQi0H+t41P/znf+xE5TIWe5xGbsvBAcLFtG8fjnGFj0g6
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [RFC PATCH V4 net-next 1/5] ethtool: Allow network drivers to
> dump arbitrary EEPROM data
> 
> > > +#define ETH_MODULE_EEPROM_PAGE_LEN	256
> >
> > Sorry to keep raising issues, but I think you want to make this
> > constant 128.
> 
> Yes, i also think the KAPI should be limited to returning a maximum of a
1/2
> page per call.
> 
> > > +#define MODULE_EEPROM_MAX_OFFSET (257 *
> > > ETH_MODULE_EEPROM_PAGE_LEN)
> >
> > The device actually has 257 addressable chunks of 128 bytes each.
> > With ETH_MODULE_EEPROM_PAGE_LEN set to 256, your constant is 2X too
> big.
> >
> > Note also, SFP devices (but not QSFP or CMIS) actually have another
> > 256 bytes available at 0x50, in addition to the full 257*128 at 0x51.
> > So SFP is actually 259*128 or (256 + 257 * 128).
> >
> > Devices that don't support pages have much lower limits (256 bytes for
> > QSFP/CMIS and 512 for SFP).  Some SFP only support 256 bytes.  Most
> > devices will return nonsense for pages above 3.  So, this check is
> > really only an absolute limit.  The SFP driver that takes this request
> > will probably check against a more refined MAX length (eg modinfo-
> >eeprom_len).
> >
> > I suggest setting this constant to 259 * (ETH_MODULE_EEPROM_PAGE_LEN
> / 2).
> > Let the driver refine it from there.
> 
> I don't even see a need for this. The offset should be within one 1/2
page, of
> one bank. So offset >= 0 and <= 127. Length is also > 0 and
> <- 127. And offset+length is <= 127.

I like the clean approach, but...   How do you request low memory?  If all
of the pages start at offset 0, then page 0 is at page 0, offset 0.  That
has always referred to low memory.  (I have actually used 'page -1' for this
in some code I don't share with others.)  I believe all of this code
currently is consistent with the paged area starting at offset 128.  If that
changes to start paged memory at offset 0, there are several places that
will need to be adjusted.

Whatever choice is made, there should be documentation scattered around in
the code, man pages and Documentation directories to tell the
user/programmer whether the paged area starts at offset 0 or offset 128.  It
is constantly confusing, and there is no obvious answer.

> 
> For the moment, please forget about backwards compatibility with the IOCTL
> interface. Lets get a new clean KAPI and a new clean internal API between
> the ethtool core and the drivers. Once we have that agreed on, we can work
> on the various compatibility shims we need to work between old and new
> APIs in various places.
> 
>       Andrew

Don

