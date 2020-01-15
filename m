Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC48E13CB96
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 19:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729107AbgAOSE3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 15 Jan 2020 13:04:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38153 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728998AbgAOSE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 13:04:29 -0500
Received: from c-67-160-6-8.hsd1.wa.comcast.net ([67.160.6.8] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1irn1j-000204-R8; Wed, 15 Jan 2020 18:04:24 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id ED9EB630E4; Wed, 15 Jan 2020 10:04:21 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id E5E42AC1CC;
        Wed, 15 Jan 2020 10:04:21 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     David Ahern <dsahern@gmail.com>
cc:     Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky <leonro@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        "vfalico@gmail.com" <vfalico@gmail.com>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Alex Rosenbaum <alexr@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Mark Zhang <markz@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
Subject: Re: Expose bond_xmit_hash function
In-reply-to: <b6ce5204-90ca-0095-a50b-a0306f61592d@gmail.com>
References: <03a6dcfc-f3c7-925d-8ed8-3c42777fd03c@mellanox.com> <20200115094513.GS2131@nanopsycho> <80ad03a2-9926-bf75-d79c-be554c4afaaf@mellanox.com> <20200115141535.GT2131@nanopsycho> <20200115143320.GA76932@unreal> <20200115164819.GX2131@nanopsycho> <b6ce5204-90ca-0095-a50b-a0306f61592d@gmail.com>
Comments: In-reply-to David Ahern <dsahern@gmail.com>
   message dated "Wed, 15 Jan 2020 10:34:04 -0700."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <26053.1579111461.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Wed, 15 Jan 2020 10:04:21 -0800
Message-ID: <26054.1579111461@famine>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> wrote:

>On 1/15/20 9:48 AM, Jiri Pirko wrote:
>>>
>>> Right now, we have one of two options:
>>> 1. One-to-one copy/paste of that bond_xmit function to RDMA.
>>> 2. Add EXPORT_SYMBOL and call from RDMA.
>>>
>>> Do you have another solution to our undesire to do copy/paste in mind?
>> 
>> I presented it in this thread.

	Having the output of bond_xmit_hash would only allow matching
the egress slave in the RDMA code to the bonding selection if the RDMA
code also peeks into the bonding internal data structures to look at
bond->slave_arr.

	This is true whether it's EXPORTed or duplicated.

>Something similar is needed for xdp and not necessarily tied to a
>specific bond mode. Some time back I was using this as a prototype:
>
>https://github.com/dsahern/linux/commit/2714abc1e629613e3485b7aa860fa3096e273cb2
>
>It is incomplete, but shows the intent - exporting bond_egress_slave for
>use by other code to take a bond device and return an egress leg.

	This seems much less awful, but would it make bonding a
dependency on pretty much everything?

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
