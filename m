Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF1253466A6
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 18:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhCWRr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 13:47:28 -0400
Received: from p3plsmtpa07-06.prod.phx3.secureserver.net ([173.201.192.235]:50551
        "EHLO p3plsmtpa07-06.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231139AbhCWRrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 13:47:07 -0400
Received: from chrisHP110 ([76.103.216.188])
        by :SMTPAUTH: with ESMTPA
        id Ol7RlGrZ6bSa5Ol7SlHue3; Tue, 23 Mar 2021 10:47:06 -0700
X-CMAE-Analysis: v=2.4 cv=OIDiYQWB c=1 sm=1 tr=0 ts=605a299a
 a=ZkbE6z54K4jjswx6VoHRvg==:117 a=ZkbE6z54K4jjswx6VoHRvg==:17
 a=kj9zAlcOel0A:10 a=VpK0EM-ZsLwCZQ5F_EUA:9 a=CjuIK1q_8ugA:10
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
References: <1616433075-27051-1-git-send-email-moshe@nvidia.com> <1616433075-27051-2-git-send-email-moshe@nvidia.com> <006801d71f47$a61f09b0$f25d1d10$@thebollingers.org> <YFk13y19yMC0rr04@lunn.ch> <007b01d71f83$2e0538f0$8a0faad0$@thebollingers.org> <YFlMjO4ZMBCcJqQ7@lunn.ch>
In-Reply-To: <YFlMjO4ZMBCcJqQ7@lunn.ch>
Subject: RE: [RFC PATCH V4 net-next 1/5] ethtool: Allow network drivers to dump arbitrary EEPROM data
Date:   Tue, 23 Mar 2021 10:47:05 -0700
Message-ID: <008901d7200c$8a59db40$9f0d91c0$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQJDEuFgm6Tcdwd/2H9v4w1v+xnhXwGLU1CXAWGs15oCOWnrmgLz6XUDAje0hBqpZ2CQkA==
Content-Language: en-us
X-CMAE-Envelope: MS4xfIl6IivOBUaBYRhuaSFFlpGPtDXqpNse5ZRGyUHip9Vj5kNp3kmlhJDbn46HOUnWjxWxcwCzdi+1w6CYCeYzJIKBJgehG9YL59spgbPKFJEQ20kEq3ZC
 6Lu9eRMQd2mMg8ZJAbc3OPcvgtQr0pN5UoipHIuAKk24cg/gmdh/A4JBCKy98U2lZymHq7YC0RLO2sV/Gt1lIcYlthL7pQjHjmxrIcm4Fc+UnCcSUMxkZVek
 B56fRjzXhUgBVifpkJCT05A0/Y0coMt4OLaVNRROU5QCmy0IhjqLihGvWY7mu9J2Rx2aJxH6bYtFpKVARfZjsz4mxZPPu/J+PbVGFVKhmPgKApVPLVcj7T8w
 ytM9b1yXAokod3ROQzBQLRnBhr71abLMTDaUU5wJS1p3YJkZbHPCiHLPDOU9Gp9tcjTeofuX
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > I don't even see a need for this. The offset should be within one
> > > 1/2
> > page, of
> > > one bank. So offset >= 0 and <= 127. Length is also > 0 and
> > > <- 127. And offset+length is <= 127.
> >
> > I like the clean approach, but...   How do you request low memory?
> 
> Duh!
> 
> I got my conditions wrong. Too focused on 1/2 pages to think that two of
> them makes one page!
> 
> Lets try again:
> 
> offset < 256
> 0 < len < 128

Actually 0 < len <= 128.  Length of 128 is not only legal, but very common.
"Read the whole 1/2 page block".

> 
> if (offset < 128)
>    offset + len < 128

Again, offset + len <= 128

> else
>    offset + len < 256

offset + len <= 256

> 
> Does that look better?
> 
> Reading bytes from the lower 1/2 of page 0 should give the same data as
> reading data from the lower 1/2 of page 42. So we can allow that, but
don't
> be too surprised when an SFP gets it wrong and gives you rubbish. I would

The spec is clear that the lower half is the same for all pages.  If the SFP
gives you rubbish you should throw the device in the rubbish.

> suggest ethtool(1) never actually does read from the lower 1/2 of any page
> other than 0.

I agree, despite my previous comment.  While the spec is clear that should
work, I believe virtually all such instances are bugs not yet discovered.

And, note that the legacy API provides no way to access lower memory from
any page but 0.  There's just no syntax for it.  Not that we care about
legacy :-).

> 
> And i agree about documentation. I would suggest a comment in
> ethtool_netlink.h, and the RST documentation.
> 
> 		   Andrew

Don


