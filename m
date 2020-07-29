Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C73231A9F
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 09:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbgG2Huk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 03:50:40 -0400
Received: from mout.web.de ([212.227.15.4]:59753 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726710AbgG2Hui (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 03:50:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1596009004;
        bh=rpT0VSgpWYfz7nGBaDEI1MxINgV+Orr2QxxF7KcolRA=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=HIGssE5WSx7RUPNxR4XJjphY9FBfsFi0fvyw1Y2uT9x9Ky6fz6tzfMLpKKn367dyQ
         mRtre0rOkhk2rv/3x0YddCbYGtjwycf4qtxoJ+E5BMlYyhjc0iVA0S3IxCoTbl5DwD
         uDsHa8yNvM9QDtq7cpc6OTNA9uT4XHJn8eW9q0pw=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.243.175.129]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MgzaT-1khSr846RR-00hOlb; Wed, 29
 Jul 2020 09:50:04 +0200
To:     Lu Wei <luwei32@huawei.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Alex Williams <alex.williams@ni.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Moritz Fischer <mdf@kernel.org>,
        Yunjian Wang <wangyunjian@huawei.com>
Subject: Re: [PATCH] net: nixge: fix potential memory leak in nixge_probe()
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <81c16524-29f0-4331-5843-9b2e2c0ee22e@web.de>
Date:   Wed, 29 Jul 2020 09:49:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
X-Provags-ID: V03:K1:ovIlmPe6AAL6mungSzbZ7Oda/uShWMBBrQuEN6CjW3Nj/EQiBIz
 G5AgL0b/x4MQSoQiYNc50qdvrgU4ka014QVPMQbv9su66dmj7dKbDNU0jcrlQ4ebQ3O/nVh
 uYnZBYZcN2r4hfMNylBFIHWGNouyxyqdprnc3eAcoKGFjoxpXgOkH4rbrk4EQKGTniMGvqK
 1hyWt6AMMGNvaZ5BpOVyg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:rs+ZIkAMwPQ=:jgWoxl8ww6VPH8Vf3l/3h6
 ezWSFCf1xM+zRKntRwxzGjiBWGWen7NO8Busirv47m9gqHHB57qIJvat3OrMjQrobP3ILEGCd
 dx0VyN43BVrt4nwl4U8FULGzvJd7ofJCWpSP/RVaJfUbcp/4iLyQIy4D5FFJhGj+RcxkeOE+G
 iVZsb6+P0nn79T+TVQW6iHC5M5o8abRNzbtZozzMa9WH7uaCRIAn+UBl2uDMP/7maH0Wu9kLf
 HhA/fL3XDFVBAztihIv14Dh1CP6jyVVwsotaM46NO/k3qwMIfYuc5LRbOT4B5cyyH/Lhyx5/M
 2iEjFK6OEJTRhrWnBS/7VZiLTyDL2qmy/jxE68IUT+Ng95fnP8zUuYN1e3I5bE5JL6BbPB2PI
 D+ZN040BybmWA8IH/R/gOTf7mmPovvZ4SHiZLEnwFS53ctNgs4cd5w0n04JnXbReNu15k4K0v
 nzc3zxn8QOb00tWsb0UJIF9vLBfn7NspRt+5ff2Z9/T/pJocZzzk/RsxgyJGSSO3HACR2Ye2W
 onvmL5KTg4XiZ/Ixg+6mJka43JK6bBAc/EPSplWAp9dQwBaaPd2mgYE3cS0D+sqePC4P/l/al
 zUFWx42AAR6Gg0iixIQ+Lk7s+7c3S23pmKtrDDwlNzPdG/f/vwuRAPArNhQTNFe8EI+TKlxQF
 asltKmj9I/e/dCEqUuRevmWlP9hVWXq+7srV0D2wB6vnzLutz12RQH8+x31AjumXrqnZ1kr6s
 S02TlaLh7bz7IERcYdB2uFtPR2n4q3VHZHJabdI8lRCusdTpdq6i2R2VY3cthqTRDPUUZlgAe
 3SHF25tWaqd43t6p7A+zqHfj+Jx+r1MUbJyXNSbDjZtvhnkd5IW1YYWItHoESTlHdswwdq/hz
 D5hWpSEGNtCBXD4jS9fEUNaVZ6NIwGj+TSnmeIKAXTxTyvBvhik1Ych4Od+xmv6K5oYLnceJg
 iSUJUf0MPJtlZrikkNZSU8xjW/K0XJxmFYN+pVjTFkqWy/gFGuNFR/83G7CzGnF1J2r13E+4Y
 sOFM3y1QUVP9PgrbsVjqXi+jwecGFeL3RoUocqkFiVvt/adyJ7x/vsA7A+s/QvMxrzmQnGQ7H
 KWR288FIlS+qNAKXvfs0G2LthR5eoiTIyeqVVLL4bpXHv6k6dUbE2whUj6Bbyrgwb/m7WeZ+c
 2pmZ/f8ycfxhy0V1PSDhkAnHafW+1V2qOo0M9NFO+9mFmnsRGOD+DNC+8ItkYc3DPVmyBPm20
 OBA8XmIvL67IEjf0nTlUo166K6MqzGszQJyQzSA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If some processes in nixge_probe() fail, free_netdev(dev)
> needs to be called to aviod a memory leak.

* Would you like to avoid a typo in this change description?

* An imperative wording can be preferred here, can't it?
  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?id=6ba1b005ffc388c2aeaddae20da29e4810dea298#n151

Regards,
Markus
