Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D40D32DFB8
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 03:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbhCECok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 21:44:40 -0500
Received: from p3plsmtpa12-03.prod.phx3.secureserver.net ([68.178.252.232]:55370
        "EHLO p3plsmtpa12-03.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229436AbhCECok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 21:44:40 -0500
Received: from chrisHP110 ([76.103.216.188])
        by :SMTPAUTH: with ESMTPA
        id I0SElezqdKlXKI0SFlxY8k; Thu, 04 Mar 2021 19:44:39 -0700
X-CMAE-Analysis: v=2.4 cv=UJAYoATy c=1 sm=1 tr=0 ts=60419b17
 a=ZkbE6z54K4jjswx6VoHRvg==:117 a=ZkbE6z54K4jjswx6VoHRvg==:17
 a=kj9zAlcOel0A:10 a=SbwqLPgDKYiBIAsG-vMA:9 a=CjuIK1q_8ugA:10
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
References: <1614884228-8542-1-git-send-email-moshe@nvidia.com> <1614884228-8542-6-git-send-email-moshe@nvidia.com> <001201d71159$88013120$98039360$@thebollingers.org> <YEGOa2NFiw3fc5sT@lunn.ch>
In-Reply-To: <YEGOa2NFiw3fc5sT@lunn.ch>
Subject: RE: [RFC PATCH V2 net-next 5/5] ethtool: Add fallback to get_module_eeprom from netlink command
Date:   Thu, 4 Mar 2021 18:44:37 -0800
Message-ID: <001801d71169$7c7ec500$757c4f00$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQFnKUugUW+R+aqYgGARCVs1/gX+XwI42Hg3AcbnmiUCE+tREqsj3zwg
Content-Language: en-us
X-CMAE-Envelope: MS4xfCXD5rAFszXw7oa5D4iCU+4wF0Ro9C43SGFqFX74e+RVKICLUu5ZmybcpQKwdQYAkCc/XLi0UUJGa6VdAKomv6amIV4r24VhuQyMByv262QU96WZyjAu
 IvYf5kJ3VQPtSmFiFs0yhyWJwdMpSMGeu4sQb+hfitcE5hQoh1RA+EPrZyDNIdTB4z+yXAVRLPfK6Ab7PcvvOaRj35RqoTj2AxIskNTDOoPqtWHVADXTV/RG
 wTPtf/FWM4pdVtGAD9LR8nahq+oC9gtdsl4Wr4wy9U5BqfArj3Dmb4ICfWoQInC8OnRoIvvbUznGMKfqQPSqp3M+JHj1Y+yda1a2ZJtIvmpGpdkcqb3TuAob
 GY4WTRIsMYQ3f/6m4zkjyrlGTHjyoMh8aPqbXTwB5zx+TpYPpZk/YxVuRKHOfG3VxRgnEqxn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +static int fallback_set_params(struct eeprom_data_req_info *request,
> > > +			       struct ethtool_modinfo *modinfo,
> > > +			       struct ethtool_eeprom *eeprom) {
> >
> > This is translating the new data structure into the old.  Hence, I
> > assume we have i2c_addr, page, bank, offset, len to work with, and we
> > should use all of them.
> 
> Nope. We actually have none of them. The old API just asked the driver to
> give me the data in the SFP. And the driver gets to decide what it
returns,
> following a well known layout. The driver can decide to give just the
first 1/2
> page, or any number of multiple 1/2 pages in a well known linear way,
which
> ethtool knows how to decode.

This code is to take a new KAPI request (a struct eeprom_data_req_info), and
create an old driver API request (a struct ethtool_eeprom) that will get the

same data.  It isn't actually fetching the data, it is just forming the data
structure
to create the request.  So, we do indeed have all of the new KAPI
parameters, 
and need to use all of them to precisely create the matching old KAPI
request.

> So when mapping the new KAPI onto the old driver API, you need to call the
> old API, and see if what is returned can be used to fulfil the KAPI
request. If
> the bytes are there, great, return them, otherwise EOPNOTSUPP.

Actually, this code has to figure out in advance whether the old API can
return
the data to fulfill the request, then form a request to accomplish that.
 
> And we also need to consider the other way around. The old KAPI is used,
> and the MAC driver only supports the new driver API. Since the linear
layout
> is well know, you need to make a number of calls into the driver to read
the
> 1/2 pages, and them glue them together and return them.

That is a great idea, probably not difficult.  It is not in this patch set.
 
> I've not reviewed this code in detail yet, so i've no idea how it actually
works.
> But i would like to see as much compatibility as possible. That has been
the
> approach with moving from IOCTL to netlink with ethool. Everything the old
> KAPI can do, netlink should also be able to, plus there can be additional
> features.
> 
> > > +	switch (modinfo->type) {
> > > +	case ETH_MODULE_SFF_8079:
> > > +		if (request->page > 1)
> > > +			return -EINVAL;
> > > +		break;
> > > +	case ETH_MODULE_SFF_8472:
> > > +		if (request->page > 3)
> >
> > Not sure this is needed, there can be pages higher than 3.
> 
> Not with the old KAPI call. As far as i remember, it stops at three pages.
But i
> need to check the ethtool(1) sources to be sure.
> 
>        Andrew


