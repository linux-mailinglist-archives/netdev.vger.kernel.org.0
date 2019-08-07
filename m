Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B450844B0
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 08:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbfHGGki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 02:40:38 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:8123 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727846AbfHGGkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 02:40:36 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d4a726c0000>; Tue, 06 Aug 2019 23:40:44 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 06 Aug 2019 23:40:34 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 06 Aug 2019 23:40:34 -0700
Received: from [10.2.165.207] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 7 Aug
 2019 06:40:34 +0000
Subject: Re: [PATCH 00/12] block/bio, fs: convert put_page() to
 put_user_page*()
To:     Christoph Hellwig <hch@infradead.org>
CC:     <john.hubbard@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jason Wang <jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Christoph Hellwig <hch@lst.de>,
        Matthew Wilcox <willy@infradead.org>, <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        <ceph-devel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <linux-cifs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <samba-technical@lists.samba.org>,
        <v9fs-developer@lists.sourceforge.net>,
        <virtualization@lists.linux-foundation.org>
References: <20190724042518.14363-1-jhubbard@nvidia.com>
 <20190724061750.GA19397@infradead.org>
 <c35aa2bf-c830-9e57-78ca-9ce6fb6cb53b@nvidia.com>
 <20190807063448.GA6002@infradead.org>
X-Nvconfidentiality: public
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <3ab1e69f-88c6-3e16-444d-cab78c3bf1d1@nvidia.com>
Date:   Tue, 6 Aug 2019 23:38:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190807063448.GA6002@infradead.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL104.nvidia.com (172.18.146.11) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1565160044; bh=jn0FnBY7ADCh0laBLX/xGqPiB9Jg8oG9YEaLS2KH1Js=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=cZhyddtfeWnuDzmY91G/o97CceVB5RM0qm7xIS+BT+DJS1yACOaMbPnxtDPonJo3O
         Ckk802AdQClg27dtVTwqZlP1rJ45uR/xJxU2tj1bAWtx6wGx8MnDwDr9/hAcMofdtY
         YSzbF7dvdBOxPO1CMgg0kHDyQnZ9XI/sZkIaiXVixuZIn5BzSqRh7aOyfPS3OIiva2
         EdoAoTR8kqTmNnuIpmqz0Mts9lp7nFil4TrfQHcFTrur14aYk9UOgpcZdRREzoyCup
         0KYEKb/ZJNSFduxPI76a4ilG78VxY7/mJHog1LdnWqMnq4OYf6DhFN3qt02E1MzswR
         TFH77+TyL//6w==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/6/19 11:34 PM, Christoph Hellwig wrote:
> On Mon, Aug 05, 2019 at 03:54:35PM -0700, John Hubbard wrote:
>> On 7/23/19 11:17 PM, Christoph Hellwig wrote:
...
>>> I think we can do this in a simple and better way.  We have 5 ITER_*
>>> types.  Of those ITER_DISCARD as the name suggests never uses pages, so
>>> we can skip handling it.  ITER_PIPE is rejected =D1=96n the direct I/O =
path,
>>> which leaves us with three.
>>>
>>
>> Hi Christoph,
>>
>> Are you working on anything like this?
>=20
> I was hoping I could steer you towards it.  But if you don't want to do
> it yourself I'll add it to my ever growing todo list.
>=20

Sure, I'm up for this. The bvec-related items are the next logical part
of the gup/dma conversions to work on, and I just wanted to avoid solving t=
he
same problem if you were already in the code.


>> Or on the put_user_bvec() idea?
>=20
> I have a prototype from two month ago:
>=20
> http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/gup-bvec
>=20
> but that only survived the most basic testing, so it'll need more work,
> which I'm not sure when I'll find time for.
>=20

I'll take a peek, and probably pester you with a few questions if I get
confused. :)

thanks,
--=20
John Hubbard
NVIDIA
