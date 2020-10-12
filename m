Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8314928AF85
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 10:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbgJLIAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 04:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726732AbgJLIAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 04:00:23 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426C2C0613CE;
        Mon, 12 Oct 2020 01:00:23 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id u8so21932924ejg.1;
        Mon, 12 Oct 2020 01:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=E6ZQVUiO2275Bcug8uUrW3WsykSr+byogH0GbMVRigw=;
        b=GcDfopve+WPhIRwCJrdYk1/TfRko9i65Ilpv8HZL+ED4dQxCulnQnRZePaC64NPAr2
         nmn49sDr6c5oTxnoaD2uTYlCVwQO8ZXYpcby1pF1D2C+klxUKxBdYIrvBNyVr+GmiuG8
         2bxGIzY8Kxom/n/9bHVET77PZ+zY76sAt0wT5b3JoLdHxzTW8+7RWqIDuoC4DkIKWI6m
         7HiNZNlq7bhlUSEqBASqo+IrjOTSLh2e3kzN+VzkPV5G32LDlCJJtFw4Om97uHa2w1yJ
         VkNWhQdsIVRQDbB1ucSjpnk/Fp3cj2MWiyRP9+YPlG7kqDkXi/dXv8baEtjIGqojK2hg
         0+vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=E6ZQVUiO2275Bcug8uUrW3WsykSr+byogH0GbMVRigw=;
        b=BeQOuwcxpOp1wFrB1Y2rJvnyX28ggCNQYAG5l8eVgAlbDVWNvU7zCHBoF1H7/MBd7b
         vt02e8acz3yYPMB4BZAdKM7ZO+54/DD/fSenqd6S2QAih+qjqSLVdbLCDl1Je9AKwG9+
         sfUkjWY/CjjCtMxY8tV8YjpjXJdjFdJfELWe0P5WSYaDHFyMMdqK/VvGPxpFJtDruQm3
         eLBBjclouDP+j4cyysP5n4Pw92dZICylVm7VPYMaNft6o9FjnNHJhlBSwrxexAqru7b/
         VkBTQKqv/KzQoUjcrNCH5ld/z1//wGiBshquPBGA7add1obPFHuA1tCiWt9eZmAQZc1E
         +7JQ==
X-Gm-Message-State: AOAM533ZbgJvreW0Re0hlzBR+yMfoStaIDqss6z6fEP613SYAAG63yw6
        WfQj9QMuyeRR4Kg9R9uQS8U=
X-Google-Smtp-Source: ABdhPJyM1WPUyaOroCzCzAQo+bFOg9gN1cdZ7Fu41hYLugilC37gIB+LcI36H/p0IumpMavqB/LCXw==
X-Received: by 2002:a17:907:4365:: with SMTP id nd5mr27607240ejb.56.1602489621917;
        Mon, 12 Oct 2020 01:00:21 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:f90c:2907:849f:701c? (p200300ea8f006a00f90c2907849f701c.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:f90c:2907:849f:701c])
        by smtp.googlemail.com with ESMTPSA id r21sm10129690eda.3.2020.10.12.01.00.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2020 01:00:21 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next v2 00/12] net: add and use function
 dev_fetch_sw_netstats for fetching pcpu_sw_netstats
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>,
        Oliver Neukum <oneukum@suse.com>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Sergey Matyukevich <geomatsi@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Pravin B Shelar <pshelar@ovn.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        bridge@lists.linux-foundation.org
Message-ID: <d77b65de-1793-f808-66b5-aaa4e7c8a8f0@gmail.com>
Date:   Mon, 12 Oct 2020 10:00:11 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In several places the same code is used to populate rtnl_link_stats64
fields with data from pcpu_sw_netstats. Therefore factor out this code
to a new function dev_fetch_sw_netstats().

v2:
- constify argument netstats
- don't ignore netstats being NULL or an ERRPTR
- switch to EXPORT_SYMBOL_GPL

Heiner Kallweit (12):
  net: core: add function dev_fetch_sw_netstats for fetching
    pcpu_sw_netstats
  IB/hfi1: use new function dev_fetch_sw_netstats
  net: macsec: use new function dev_fetch_sw_netstats
  net: usb: qmi_wwan: use new function dev_fetch_sw_netstats
  net: usbnet: use new function dev_fetch_sw_netstats
  qtnfmac: use new function dev_fetch_sw_netstats
  net: bridge: use new function dev_fetch_sw_netstats
  net: dsa: use new function dev_fetch_sw_netstats
  iptunnel: use new function dev_fetch_sw_netstats
  mac80211: use new function dev_fetch_sw_netstats
  net: openvswitch: use new function dev_fetch_sw_netstats
  xfrm: use new function dev_fetch_sw_netstats

 drivers/infiniband/hw/hfi1/ipoib_main.c       | 34 +------------------
 drivers/net/macsec.c                          | 22 +-----------
 drivers/net/usb/qmi_wwan.c                    | 24 +------------
 drivers/net/usb/usbnet.c                      | 24 +------------
 drivers/net/wireless/quantenna/qtnfmac/core.c | 27 +--------------
 include/linux/netdevice.h                     |  2 ++
 net/bridge/br_device.c                        | 21 +-----------
 net/core/dev.c                                | 34 +++++++++++++++++++
 net/dsa/slave.c                               | 21 +-----------
 net/ipv4/ip_tunnel_core.c                     | 23 +------------
 net/mac80211/iface.c                          | 23 +------------
 net/openvswitch/vport-internal_dev.c          | 20 +----------
 net/xfrm/xfrm_interface.c                     | 22 +-----------
 13 files changed, 47 insertions(+), 250 deletions(-)

-- 
2.28.0



