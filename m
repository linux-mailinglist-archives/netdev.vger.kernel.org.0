Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF66C33DFAD
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 22:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbhCPVAp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 16 Mar 2021 17:00:45 -0400
Received: from p3plsmtpa08-07.prod.phx3.secureserver.net ([173.201.193.108]:46732
        "EHLO p3plsmtpa08-07.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232149AbhCPVAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 17:00:25 -0400
Received: from chrisHP110 ([76.103.216.188])
        by :SMTPAUTH: with ESMTPA
        id MGnflxIstW7O2MGnglYlxn; Tue, 16 Mar 2021 14:00:24 -0700
X-CMAE-Analysis: v=2.4 cv=dpEet3s4 c=1 sm=1 tr=0 ts=60511c68
 a=ZkbE6z54K4jjswx6VoHRvg==:117 a=ZkbE6z54K4jjswx6VoHRvg==:17
 a=IkcTkHD0fZMA:10 a=Ikd4Dj_1AAAA:8 a=pFxyTi4Pl4_mBTJLaogA:9
 a=7Tosw6CldfATm1kQ:21 a=JYVWiYVlfnQAFU0k:21 a=QEXdDO2ut3YA:10
X-SECURESERVER-ACCT: don@thebollingers.org
From:   "Don Bollinger" <don@thebollingers.org>
To:     "'Moshe Shemesh'" <moshe@nvidia.com>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'Andrew Lunn'" <andrew@lunn.ch>,
        "'Adrian Pop'" <pop.adrian61@gmail.com>,
        "'Michal Kubecek'" <mkubecek@suse.cz>, <netdev@vger.kernel.org>,
        <don@thebollingers.org>
Cc:     "'Vladyslav Tarasiuk'" <vladyslavt@nvidia.com>
References: <1615828363-464-1-git-send-email-moshe@nvidia.com> <1615828363-464-2-git-send-email-moshe@nvidia.com> <002201d719ea$e60d9350$b228b9f0$@thebollingers.org> <0a8beb69-972b-3b00-a67e-0e97f9fda8ea@nvidia.com>
In-Reply-To: <0a8beb69-972b-3b00-a67e-0e97f9fda8ea@nvidia.com>
Subject: RE: [RFC PATCH V3 net-next 1/5] ethtool: Allow network drivers to dump arbitrary EEPROM data
Date:   Tue, 16 Mar 2021 14:00:21 -0700
Message-ID: <006b01d71aa7$619eb2d0$24dc1870$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQGz6jCTEjXEF5R9RRlUkJN6q0cH4gF9RYA5AeDMSfcCkMhM+qqd//ZQ
Content-Language: en-us
X-CMAE-Envelope: MS4xfH88+mN4+HsyVYzppgrULnb0jfZtwTAZsGpf37BY3LiuQc3VFm7jkHtHtUnal+9ydQsbIvO837N+7z2S7wAwWUXGieakwXp0qWNC1hDLy11ps/4LZjl7
 Im7UN//klt0g055oQ6tuKV7+skRGY8Jv3lDzLnZ6FbG9yvcryppY32plgSG3Np3xKUMo+5YRp72tEsRxO7/iQWVvRed63hqEyKEPS7nrCkulkkQt9Yuk7K4I
 ztKnbvFoWTGZgOqWSV1BOWlHcum8FkH+pjJAobTvTjg0LhKlAOd+Q10fUg6ql+Z47fTZW6yCoPsOjqI79o++36uVAvY8SHmg06msa2rRkr7Q3HYYl6TxaVfL
 5YC2PDi3hUUsWyIMcVFF0fqCQEWwEpmKdlfaDukIoU8Wg013lbAsQ/obRsY+jhmSLINNmrqq
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/16/2021 11:24 AM, Moshe Shemesh wrote:
> On 3/16/2021 12:31 AM, Don Bollinger wrote:
> > On Mon, 15 Mar 2021 10:12:39 +0700 Moshe Shemesh wrote:
> >> From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
> >>
> >> Define get_module_eeprom_data_by_page() ethtool callback and
> >> implement netlink infrastructure.
> >>

<snip>

> >> +     request->offset =
> >> nla_get_u32(tb[ETHTOOL_A_EEPROM_DATA_OFFSET]);
> >> +     request->length =
> >> nla_get_u32(tb[ETHTOOL_A_EEPROM_DATA_LENGTH]);
> >> +     if (tb[ETHTOOL_A_EEPROM_DATA_PAGE] &&
> >> +         dev->ethtool_ops->get_module_eeprom_data_by_page &&
> >> +         request->offset + request->length >
> >> ETH_MODULE_EEPROM_PAGE_LEN)
> >> +             return -EINVAL;
> > If a request exceeds the length of EEPROM (in legacy), we truncate it
> > to EEPROM length.  I suggest if a request exceeds the length of the
> > page (in the new KAPI), then we truncate at the end of the page.  Thus
> > rather than 'return -EINVAL;' I suggest
> >
> >            request->length = ETH_MODULE_EEPROM_PAGE_LEN -
> > request->offset;
> 
> I was not sure about that, isn't it better that once user specified page he has
> to be in the page boundary and let him know the command failed ?

On further review, I agree with your original code.  Reading across a page boundary will require explicit tracking of offset and page to read from.  If you get a short read, you *might* have to update the page on the next read.  If you have to keep track of where the page boundary is and adjust the offset and page together, then you should be explicitly managing not to try to read across a page boundary.  Put another way, if you try to read across a page boundary you probably have a bug in your code and will appreciate an immediate error.

I withdraw my previous suggestion, don't change it.

Don

