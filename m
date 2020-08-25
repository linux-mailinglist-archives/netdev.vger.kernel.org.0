Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADCFD2521E5
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 22:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgHYUWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 16:22:06 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:49118 "EHLO
        asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgHYUWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 16:22:05 -0400
Received: from ravnborg.org (unknown [188.228.123.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by asavdk3.altibox.net (Postfix) with ESMTPS id 199B620024;
        Tue, 25 Aug 2020 22:21:54 +0200 (CEST)
Date:   Tue, 25 Aug 2020 22:21:53 +0200
From:   Sam Ravnborg <sam@ravnborg.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Xinliang Liu <xinliang.liu@linaro.org>,
        Wanchun Zheng <zhengwanchun@hisilicon.com>,
        linuxarm@huawei.com, dri-devel <dri-devel@lists.freedesktop.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devel@driverdev.osuosl.org, Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Xiubin Zhang <zhangxiubin1@huawei.com>,
        Wei Xu <xuwei5@hisilicon.com>, David Airlie <airlied@linux.ie>,
        Xinwei Kong <kong.kongxinwei@hisilicon.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Bogdan Togorean <bogdan.togorean@analog.com>,
        Laurentiu Palcu <laurentiu.palcu@nxp.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Liwei Cai <cailiwei@hisilicon.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Chen Feng <puck.chen@hisilicon.com>,
        Alexei Starovoitov <ast@kernel.org>,
        linaro-mm-sig@lists.linaro.org, Rob Herring <robh+dt@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, mauro.chehab@huawei.com,
        Rob Clark <robdclark@chromium.org>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liuyao An <anliuyao@huawei.com>,
        Rongrong Zou <zourongrong@gmail.com>, bpf@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 00/49] DRM driver for Hikey 970
Message-ID: <20200825202153.GA237836@ravnborg.org>
References: <cover.1597833138.git.mchehab+huawei@kernel.org>
 <20200819152120.GA106437@ravnborg.org>
 <20200819174027.70b39ee9@coco.lan>
 <20200819173558.GA3733@ravnborg.org>
 <20200821155801.0b820fc6@coco.lan>
 <20200821155505.GA300361@ravnborg.org>
 <20200824180225.1a515b6a@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824180225.1a515b6a@coco.lan>
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=f+hm+t6M c=1 sm=1 tr=0
        a=S6zTFyMACwkrwXSdXUNehg==:117 a=S6zTFyMACwkrwXSdXUNehg==:17
        a=kj9zAlcOel0A:10 a=e5mUnYsNAAAA:8 a=jmfwfdV-BNFhccFjUE8A:9
        a=CjuIK1q_8ugA:10 a=pBTelFdiagIA:10 a=Vxmtnl_E_bksehYqCbjh:22
        a=pHzHmUro8NiASowvMSCR:22 a=xoEH_sTeL_Rfw54TyV31:22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mauro.

Laurent and I discussed this driver a little on irc.
Some highlights:

This parts could use register names:
+       writel(0x2, noc_dss_base + 0xc);
+       writel(0x2, noc_dss_base + 0x8c);
+       writel(0x2, noc_dss_base + 0x10c);
+       writel(0x2, noc_dss_base + 0x18c);

The two nodes in the DT for DPE and DSI uses overlapping range for reg
entries. It looks like a syscon node or some iommu thing is needed to do
this properly.

The chain will lok like this:

DPE -> DSI -> video mux -> {adv7533, panel}

But drm_bridge has not yet support for such non-linear setup.
The recommendation is to focus on the HDMI prat. Then we can later
come up with support for a video mux.

The video mux should have a dedicated node with one input node and two
output nodes. Which is also where the gpio should be.

The DSI node references two DPHY instances - should it be PHY driver(s)?

Does the DSI part contain one or two instances. Clocks looks duplicated.

Does the DPE and DSI share a lot of register blocks - or does it just
look like this from a first point of view?

You can read though the logs here:
https://people.freedesktop.org/~cbrill/dri-log/index.php

Could you please try to get back on some of the points above so we can
help you move forward in the right direction.

Thanks,
	Sam
