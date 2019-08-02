Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E86E97EA6F
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 04:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728951AbfHBCjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 22:39:05 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:11756 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbfHBCjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 22:39:04 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d43a24e0000>; Thu, 01 Aug 2019 19:39:10 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 01 Aug 2019 19:39:01 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 01 Aug 2019 19:39:01 -0700
Received: from [10.110.48.28] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 2 Aug
 2019 02:39:00 +0000
Subject: Re: [PATCH 00/34] put_user_pages(): miscellaneous call sites
To:     <john.hubbard@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
CC:     Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        <amd-gfx@lists.freedesktop.org>, <ceph-devel@vger.kernel.org>,
        <devel@driverdev.osuosl.org>, <devel@lists.orangefs.org>,
        <dri-devel@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <kvm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-block@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-nfs@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-rpi-kernel@lists.infradead.org>,
        <linux-xfs@vger.kernel.org>, <netdev@vger.kernel.org>,
        <rds-devel@oss.oracle.com>, <sparclinux@vger.kernel.org>,
        <x86@kernel.org>, <xen-devel@lists.xenproject.org>
References: <20190802021653.4882-1-jhubbard@nvidia.com>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <ec87b662-0fc2-0951-1337-a91b4888201b@nvidia.com>
Date:   Thu, 1 Aug 2019 19:39:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190802021653.4882-1-jhubbard@nvidia.com>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1564713550; bh=uB7qKWJf2vIk7MCI51NrKGKnU0tjP3n9YQM4FSsQ99A=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=aftmkmmNomCdfG4/nsU7QFjmse0kzSiVn7k6qdyITGQKtpIb7fXB3ira93x2ikjhP
         hh9fWh6OxSH7I4ITUxx9rk4nMXoUcCl6xE7j7d8OaKs0QzK3tWjGXYe1PPsA5+CMkF
         sKiN+5/hdBTh4TsmJWAPetkvcksKG1W7KX4K24lGpfHw6t/QQ4fbKf5zlriq/zHiCI
         WN7lLvY4tFrWOLTfdOFRIa/sFBuq00RVcHrLnsHi/Dnbw2dVeWXrugMTAYnP04jnRA
         tXP1GLNpYcsDC/T0sb/csl6pvYXC87xnKjlVca8dQdSp/cuFTGUobSHcHyKfqM9q/X
         eCw5n+JFkzHyg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/1/19 7:16 PM, john.hubbard@gmail.com wrote:
> From: John Hubbard <jhubbard@nvidia.com>
> 
> Hi,
> 
> These are best characterized as miscellaneous conversions: many (not all)
> call sites that don't involve biovec or iov_iter, nor mm/. It also leaves
> out a few call sites that require some more work. These are mostly pretty
> simple ones.
> 
> It's probably best to send all of these via Andrew's -mm tree, assuming
> that there are no significant merge conflicts with ongoing work in other
> trees (which I doubt, given that these are small changes).
> 

In case anyone is wondering, this truncated series is due to a script failure:
git-send-email chokes when it hits email addresses whose names have a
comma in them, as happened here with patch 0003.  

Please disregard this set and reply to the other thread.

thanks,
-- 
John Hubbard
NVIDIA
