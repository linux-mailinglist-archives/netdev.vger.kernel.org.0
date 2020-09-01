Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A383E2599A2
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 18:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732241AbgIAQmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 12:42:10 -0400
Received: from mout.gmx.net ([212.227.15.19]:55739 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730334AbgIAQmA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 12:42:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1598978476;
        bh=iS+KmbY1ndEJSpXJ6ApP71r110vbaj/m88hnuZyQwTA=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:References:Date:In-Reply-To;
        b=Ub1CAZJYKYLiobVhHR8Et1pUU6d5a0ERsK2MsY7wzhw0HjhUjXhJSc4b4w7JLVY2K
         imx2QUOs2xWvIZbhXholxKb0puJB9y9zCeV2KFD9q6C/NjJJszwTuwNoPvI/AfTNic
         kg6J1s8vPoCo/SATwJopqTMYp2II/N+zrO+5Tf7M=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.20.60] ([92.116.187.2]) by mail.gmx.com (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MqaxO-1kzdF62DEe-00mXqh; Tue, 01
 Sep 2020 18:41:16 +0200
Subject: Re: [PATCH 07/28] 53c700: improve non-coherent DMA handling
From:   Helge Deller <deller@gmx.de>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        iommu@lists.linux-foundation.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ia64@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        nouveau@lists.freedesktop.org, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-mm@kvack.org, alsa-devel@alsa-project.org
References: <20200819065555.1802761-1-hch@lst.de>
 <20200819065555.1802761-8-hch@lst.de>
 <1598971960.4238.5.camel@HansenPartnership.com>
 <20200901150554.GN14765@casper.infradead.org>
 <1598973776.4238.11.camel@HansenPartnership.com>
 <3369218e-eea4-14e9-15f1-870269e4649d@gmx.de>
Autocrypt: addr=deller@gmx.de; keydata=
 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
 c2TFWAS8k6RLkk41ZUU8ENX8+qZx/Q==
Message-ID: <77c9b2b6-bedc-d090-8b23-6ac664df1d1f@gmx.de>
Date:   Tue, 1 Sep 2020 18:41:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <3369218e-eea4-14e9-15f1-870269e4649d@gmx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:4Y8gxSC3mimemrR4PtvEKNwyw28FqcRZSkoK2gQkqvo/KOoRbTg
 w40kQskhrNaheI6REKgULCG68Fy6MEYc0KsJy9WRPUH71+WKoerrwaE3EISLn47wt9qPakq
 Z9gMZCEqcjMGAkwuPOCtdfBULoqR2MkqoEWEFsPLv/Ad3iHMpMr0z0ACL6exzE1IUZ+o2Jw
 GUtUnwHdeUzKCJ46isMYw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:4lG/PGFS7YQ=:rR2RWvp5WhtvYGYgat1e00
 0rF5u2mtUMkAk5WSd9Aa85NoBhY1TSBoWKZBCJ4rwtlnRn8wdTBwkngGfwpVVlNUoTFLjSyrV
 dM46jjweSnPFr8XhH+kUbZi8nfv6BYzG7I3YF2PswSg74hJGslsbwd81I/cZ8KPvjSLwgvlMG
 qic+xZolA+MdQVgJGn64EkYW1DlcXV4gMG9LXW4+9553DiKfcM+5/zwWxw0cpO6Jnoe1L7rrA
 kOYQmwe1wTN3lP6q4Xz99dj7FqfZVVuegxF6peou2o6w+ITCPtuLm6egQPtVE3C6amruAZb29
 glICo0l6SpftC4oBEVgkOIRfdQ2jQlwZcG9QmH3rSp9u2BHEwOTXSLJGiNFvzVoeqt4t7uyVj
 eXAkUz9hT0d3IU2KosWY3+BLBxNPncgp0/VCs5JvwdO2SHDAByGYT2FqbPFevV9b4XMT/M5PU
 eh/og76n7UYqpMe+mlzJq5cKbAJVu450dqW7JGEm/PibmF9c0u6QJTppVgX6yAGLFMQI5O9xU
 2apy5bcA5aU8jWW9cDTNCwuqkNw0U0/2WWfyQEKJTgRxKgJBU0sIEczgDpxOO5RTNcdBtGFBs
 V8jzcgpZ5KsngR5t2lWAZMzdwZVP34TfYH1XK6c0CVgBD47Sw5eX5U1Q0rCy37oNa6YIXTE9a
 Xp6aYP4h3KFkk0s/RoT6Ke1bjKj3Va5B9o5MciBLLx7WvEBlZXYF/EEysP4bV82Xrv5FGgcOg
 oh52J5bfjodQ5wWNdaRK+e38oUkyRhmURb3XRxrW2fDrcBCchtAsE9mGJ6LB5fBtmYoRsJTmf
 cXUesL8SjI8AG1F15nWfDKKjsgJI9i4Nv1rLO7jSenStdlCv9bzYkzFYplFgiJQ7cLqwWvAjc
 7CPUrsYcLfK4Wbdm0m/VUh6wASK8K0QNytwoXTs/ljGIIK4U52UZJrzgFAKQJhXuVubth+eZY
 AZkmQQLpSFPMuX6IF1nH1Mc2UjtK1Cp2LEUeAnKDI1fCjiem+fClfbf2G10U0l3tob6wDRsRI
 t7OdZsZXe0f7TM/u0vGP4R9Cwsl6Fho63YI7D5w6/u5NL5QGtBDEC95y9+G63wmiXSBcng3A4
 1UTqryoUHc8aKHXYqF84O5q/rWzFMRztwG8wy1uv0KBlIypD0gFTmCI+GG5eMT7pfTy4hzJ0B
 r5KBGKxghDj+/3MGdhdvMFOuYS5qssBiWkis3r4/O5Ueg/OUyPJBrZmB18VBFEydfdyctQt6r
 mkZNnjtzj1HuFIBiQ
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.09.20 18:21, Helge Deller wrote:
> On 01.09.20 17:22, James Bottomley wrote:
>> On Tue, 2020-09-01 at 16:05 +0100, Matthew Wilcox wrote:
>>> On Tue, Sep 01, 2020 at 07:52:40AM -0700, James Bottomley wrote:
>>>> I think this looks mostly OK, except for one misnamed parameter
>>>> below. Unfortunately, the last non-coherent parisc was the 700
>>>> series and I no longer own a box, so I can't test that part of it
>>>> (I can fire up the C360 to test it on a coherent arch).
>>>
>>> I have a 715/50 that probably hasn't been powered on in 15 years if
>>> you need something that old to test on (I believe the 725/100 uses
>>> the 7100LC and so is coherent).  I'll need to set up a cross-compiler
>>> ...
>>
>> I'm not going to say no to actual testing, but it's going to be a world
>> of pain getting something so old going.  I do have a box of older
>> systems I keep for architectural testing that I need to rummage around
>> in ... I just have a vague memory that my 715 actually caught fire a
>> decade ago and had to be disposed of.
>
> I still have a zoo of machines running for such testing, including a
> 715/64 and two 730.
> I'm going to test this git tree on the 715/64:
> git://git.infradead.org/users/hch/misc.git dma_alloc_pages

This tree boots nicely (up to a command prompt with i82596 nic working):

53c700: Version 2.8 By James.Bottomley@HansenPartnership.com
scsi0: 53c710 rev 2
scsi host0: LASI SCSI 53c700
scsi 0:0:6:0: Direct-Access     QUANTUM  FIREBALL_TM3200S 300X PQ: 0 ANSI:=
 2
scsi target0:0:6: Beginning Domain Validation
scsi 0:0:6:0: tag#56 Enabling Tag Command Queuing
scsi target0:0:6: asynchronous
scsi target0:0:6: FAST-10 SCSI 10.0 MB/s ST (100 ns, offset 8)
scsi target0:0:6: Domain Validation skipping write tests
scsi target0:0:6: Ending Domain Validation
scsi 0:0:6:1: tag#63 Disabling Tag Command Queuing
st: Version 20160209, fixed bufsize 32768, s/g segs 256
sd 0:0:6:0: Power-on or device reset occurred
sd 0:0:6:0: Attached scsi generic sg0 type 0
LASI 82596 driver - Revision: 1.30
Found i82596 at 0xf0107000, IRQ 17
eth0: 82596 at 0xf0107000, 08:00:09:c2:9e:60 IRQ 17.
sd 0:0:6:0: [sda] 6281856 512-byte logical blocks: (3.22 GB/3.00 GiB)
sd 0:0:6:0: [sda] Write Protect is off

Christoph, you may add a
Tested-by: Helge Deller <deller@gmx.de> # parisc
to the series.

Helge
