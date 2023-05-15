Return-Path: <netdev+bounces-2676-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 18AEA703047
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 16:43:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC6821C20C12
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 14:43:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0F4DC8E5;
	Mon, 15 May 2023 14:43:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E002F8836
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 14:43:25 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78A02D67;
	Mon, 15 May 2023 07:43:24 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34FEdfW2001912;
	Mon, 15 May 2023 14:42:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=3xmrodnLEt3plr6PfR2NiDKXpK4TnrjIaL6sDzQ/7GU=;
 b=q+a2WxQK3J7w6NJiJUphIIf9ajPoK7dLJYqI+t2yd270W7CmFhfqcxPQ4sLDs8I3yoHG
 pxet7qhizsDe49r5qacnn0up7txnPYLcrU93fC8Bm+i3aeBN80Ggy2bsIoIYrG+r6kUc
 J1XYXBbpdTFIkOMbNS2Hzs4i6D8uAWoosggxD2ywApVOUoB3k+0BLdM34/EKgjTr0v0I
 M1Qugs2xEIxBRanx3Lb4zTEg+aHcUy6ykjy9rtQaZ1BfcKCrOV62c4cgy2n4HHtWIcJg
 tOJu+la3PVYmFqjAttTuVrNtJHuyBkPyuDeqcvdGca4YJcbHej4ZLYZBslN6wQePhEil xg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qkpes0q07-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 May 2023 14:42:47 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34FEe63m005221;
	Mon, 15 May 2023 14:42:46 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qkpes0pvy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 May 2023 14:42:46 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
	by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34FD2VOD016196;
	Mon, 15 May 2023 14:42:43 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3qj264rxmt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 May 2023 14:42:42 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34FEgdw220447944
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 May 2023 14:42:39 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4949420043;
	Mon, 15 May 2023 14:42:39 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DF9C920040;
	Mon, 15 May 2023 14:42:36 +0000 (GMT)
Received: from [9.171.65.23] (unknown [9.171.65.23])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 15 May 2023 14:42:36 +0000 (GMT)
Message-ID: <a2a9a2bdb431d7611588a9f9bdca64856ac56139.camel@linux.ibm.com>
Subject: Re: [PATCH v9 5/6] iommu/dma: Allow a single FQ in addition to
 per-CPU FQs
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Robin Murphy <robin.murphy@arm.com>
Cc: Joerg Roedel <joro@8bytes.org>, Matthew Rosato <mjrosato@linux.ibm.com>,
        Will Deacon <will@kernel.org>, Wenjia Zhang <wenjia@linux.ibm.com>,
        Gerd
 Bayer <gbayer@linux.ibm.com>,
        Julian Ruess <julianr@linux.ibm.com>,
        Pierre
 Morel <pmorel@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Suravee
 Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Hector Martin
 <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig
 <alyssa@rosenzweig.io>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu
 <baolu.lu@linux.intel.com>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson
 <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Yong Wu
 <yong.wu@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Orson Zhai
 <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Chunyan
 Zhang <zhang.lyra@gmail.com>, Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec
 <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Thierry
 Reding <thierry.reding@gmail.com>,
        Krishna Reddy <vdumpa@nvidia.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux.dev, asahi@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-tegra@vger.kernel.org, linux-doc@vger.kernel.org
Date: Mon, 15 May 2023 16:42:36 +0200
In-Reply-To: <ZGIuj2pRjOPffqZZ@ziepe.ca>
References: <20230310-dma_iommu-v9-0-65bb8edd2beb@linux.ibm.com>
	 <20230310-dma_iommu-v9-5-65bb8edd2beb@linux.ibm.com>
	 <ZGIuj2pRjOPffqZZ@ziepe.ca>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.48.1 (3.48.1-1.fc38) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gNuxWXJsmokdhsaD92T6yUFS_UMSNhrG
X-Proofpoint-ORIG-GUID: me_7t4m8_jWebgWrnvUvQ84qdxzJLwc5
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-15_11,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 phishscore=0 spamscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=596 bulkscore=0 impostorscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2304280000 definitions=main-2305150121
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, 2023-05-15 at 10:07 -0300, Jason Gunthorpe wrote:
> On Mon, May 15, 2023 at 11:15:55AM +0200, Niklas Schnelle wrote:
>=20
> > +/**
> > + * struct dma_iommu_options - Options for dma-iommu
> > + *
> > + * @flags: Flag bits for enabling/disabling dma-iommu settings
> > + *
> > + * This structure is intended to provide IOMMU drivers a way to influe=
nce the
> > + * behavior of the dma-iommu DMA API implementation. This allows optim=
izing for
> > + * example for a virtualized environment with slow IOTLB flushes.
> > + */
> > +struct dma_iommu_options {
> > +#define IOMMU_DMA_OPTS_PER_CPU_QUEUE	(0L << 0)
> > +#define IOMMU_DMA_OPTS_SINGLE_QUEUE	(1L << 0)
> > +	u64	flags;
> > +};
>=20
> You need to hash it out with robin if we do something like this or use
> more untyped caps as he put in this series:
>=20
> https://lore.kernel.org/linux-iommu/cover.1683233867.git.robin.murphy@arm=
.com/
>=20
> Jason

Ok. I do wonder how to best represent this as a capability.
Semantically I think a capability needs to be something positive i.e.
while IOMMU_CAP_EXPENSIVE_FLUSH would technically work having slow
IOTLB flushes really isn't a capability. So the best I can think of is
maybe IOMMU_CAP_SHADOW_ON_FLUSH. It's a bit specific but does convey
that the IOTLB flush does more than dropping hardware caches where the
main cost is the then empty TLB not the operation itself. Or maybe to
keep thing separate one would have to add capabilities for the existing
users IOMMU_CAP_HW_FLUSH and IOMMU_CAP_CONCURRENT_FLUSH.

Not sure though. It does feel more clunky than the tuning op I added
and maybe instead these mechanisms should co-exist. After all even
though the IOTLB flushes with shadowing are expensive they still
benefit from the flush queue just with more entries and less
parallelism.

Thanks,
Niklas

