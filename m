Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4750432DFC9
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 03:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbhCECyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 21:54:02 -0500
Received: from p3plsmtpa08-09.prod.phx3.secureserver.net ([173.201.193.110]:42886
        "EHLO p3plsmtpa08-09.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229436AbhCECyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 21:54:02 -0500
Received: from chrisHP110 ([76.103.216.188])
        by :SMTPAUTH: with ESMTPA
        id I0bHlQHIBAxvlI0bJljjo1; Thu, 04 Mar 2021 19:54:01 -0700
X-CMAE-Analysis: v=2.4 cv=SvpVVNC0 c=1 sm=1 tr=0 ts=60419d49
 a=ZkbE6z54K4jjswx6VoHRvg==:117 a=ZkbE6z54K4jjswx6VoHRvg==:17
 a=kj9zAlcOel0A:10 a=VDEnwLAwkv6ndcAumr0A:9 a=CjuIK1q_8ugA:10
X-SECURESERVER-ACCT: don@thebollingers.org
From:   "Don Bollinger" <don@thebollingers.org>
To:     "'Moshe Shemesh'" <moshe@nvidia.com>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'Andrew Lunn'" <andrew@lunn.ch>,
        "'Adrian Pop'" <pop.adrian61@gmail.com>,
        "'Michal Kubecek'" <mkubecek@suse.cz>, <netdev@vger.kernel.org>
Cc:     "'Vladyslav Tarasiuk'" <vladyslavt@nvidia.com>,
        <don@thebollingers.org>
References: <1614884228-8542-1-git-send-email-moshe@nvidia.com> <1614884228-8542-6-git-send-email-moshe@nvidia.com> <001201d71159$88013120$98039360$@thebollingers.org>
In-Reply-To: <001201d71159$88013120$98039360$@thebollingers.org>
Subject: RE: [RFC PATCH V2 net-next 5/5] ethtool: Add fallback to get_module_eeprom from netlink command
Date:   Thu, 4 Mar 2021 18:53:58 -0800
Message-ID: <001b01d7116a$cb64b7a0$622e26e0$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQFnKUugUW+R+aqYgGARCVs1/gX+XwI42Hg3AcbnmiWrNIJnAA==
Content-Language: en-us
X-CMAE-Envelope: MS4xfP4StaMiu5Kph5iOsZwxBfh60p3n91f2XZvzyfN+3ysDz2skcIw2JjxwgivdNThnxf21tkTsfiY8OOa1XDRMY0GR9IVjx0Y12c3oOlWrZFMOLIwNkcke
 f1AUsyKM0xvOFK9kxvp7gIkUCbLN6urPK2SOfe+q7/hiCgMbm5DoRF1A0s5ab0L02o3NYnSBTgvzSLREmt2lifSpd/AxIh4pUCij26q5dYgQEo06FUTlThyo
 sUO4iBy/wXYLM+Yu6v915Uh+lFZdCkuqWGyP2w20Yg/8UnZvdbmIyEJ3ASnzYGyNSBNikOTXwkBpQk6MNHbh4HY29UOJBpjGANwWS0qyWctHk1mQpgqTTXQp
 uBYNvrBr/yk4Xn2knzMs/X+PXOcn62BbcMAQEPTe88wxiDhdJR7JSgMP7CLu8lB17GdvHex2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > --- a/net/ethtool/eeprom.c
> > +++ b/net/ethtool/eeprom.c
> > @@ -26,6 +26,88 @@ struct eeprom_data_reply_data {  #define
> > EEPROM_DATA_REPDATA(__reply_base) \
> >  	container_of(__reply_base, struct eeprom_data_reply_data, base)
> >
> > +static int fallback_set_params(struct eeprom_data_req_info *request,
> > +			       struct ethtool_modinfo *modinfo,
> > +			       struct ethtool_eeprom *eeprom) {
> 
> This is translating the new data structure into the old.  Hence, I assume
we
> have i2c_addr, page, bank, offset, len to work with, and we should use all
of
> them.  We shouldn't be applying the legacy data structure's rules to how
we
> interpret the *request data.  Therefore...
> 
> > +	u32 offset = request->offset;
> > +	u32 length = request->length;
> > +
> > +	if (request->page)
> > +		offset = 128 + request->page * 128 + offset;
> 
> This is tricky to map to old behavior.  The new data structure should give
> lower memory for offsets less than 128, and paged upper memory for
> offsets of 128 and higher.  There is no way to describe that request as
> {offset, length} in the old ethtool format with a fake linear memory.
> 
>         if (request->page) {
>                 if (offset < 128) && (offset + length > 128)
>                        return -EINVAL;

Actually, reflecting on Andrew's response, it occurs to me this does not
have to be an error.  The routine eeprom_data_fallback() (below) could
detect this case (a request crossing the 128 byte offset boundary) and
create two requests, one for lower memory and one for the paged 
upper memory.  That can't be done as a single request with the linear
memory model, but the two pieces can be read separately and glued
together.

Don


