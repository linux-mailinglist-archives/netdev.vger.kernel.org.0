Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6822D4FE2A1
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356212AbiDLN3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356711AbiDLN2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:28:05 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88CE54C7BA
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 06:23:10 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id bv19so14302327ejb.6
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 06:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rXcg/Ype6uIjAfItNQAeju/b1MZ4MA2DUyLT61aVEJg=;
        b=ho8/oNzeHh3Ove26Fwrioqw6uhrhj0e8tkOLNuR/pi0fvXwg633sDqj9xLvPUDvysu
         A/xepluGssYLK2Ygr8qj3ihfmYrkPPegK2w4WPEGwLnbMmMamGaOwjDNYi/3zfErTzpp
         KSgvO/XOALbrPoNkM45z3d2/Y3gEXCznueTNSF6cKvcrhHtdEb9HjW/VXeFOOKqg+ePt
         rZox3IIxSluikPQd9+S2IQAQiVE2rnJE/TRV2SaopC0+FFT8rQHWUZAjXykQ7jiQC5Im
         1Uyk6Yj1+Tn/ZolrHM1BJNfX+T4EgnkypUdsMMdW0McSKrkQiaoHakAh5mni1OH/wHz3
         z2eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rXcg/Ype6uIjAfItNQAeju/b1MZ4MA2DUyLT61aVEJg=;
        b=onQhpy9J7euwq0dWzE72m6fhMrT6O0e8IOI1i5racVs4bgWKJTNyw3VDNq9cEwmVaR
         QRQdcI1w+qcc57hx+LvvpYN5/auNNdtmA7esCGYr5LJzQxWVHSibiWM5TwDoexFcrzEe
         4fGI9yWoMHwMsXJLaflP0s4eZgzLwRlcLunMk8dlAUCdnuTDaATuaHpBtqTg3SkR2bi5
         KS9z2A+GPk2DrfZe75bxvpD3PHPStYkDgkVzf4TYSp+oqWJKbS00LmJDv/YeUSC7oWem
         fT+ONIuxKDeS9T2TFCAugxNOGTOFjO35l7gfG+vCHji3uUXY3ZrE6M71Lwd8HFoem+2K
         Lhrw==
X-Gm-Message-State: AOAM533wm3CE+1NOgSLrcBfFOzCr4FP7AJeny5K1GC5xBauGK8UebX5R
        aT8ef/cQJxbiM/MsK/WiIpEXjg7NcE9B5T4J
X-Google-Smtp-Source: ABdhPJwD7hgLfdN/SI1BMksaOg7fdHOuVcng9TaGPBuz0qQgNtkPIqGBVsgDJgrUlDCcE1aH7Cvhlg==
X-Received: by 2002:a17:906:7950:b0:6e0:6f49:c90 with SMTP id l16-20020a170906795000b006e06f490c90mr35095875ejo.156.1649769788488;
        Tue, 12 Apr 2022 06:23:08 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id z16-20020a17090665d000b006e8789e8cedsm3771301ejn.204.2022.04.12.06.23.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 06:23:07 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org, roopa@nvidia.com, idosch@idosch.org,
        kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net-next v3 0/8] net: bridge: add flush filtering support
Date:   Tue, 12 Apr 2022 16:22:37 +0300
Message-Id: <20220412132245.2148794-1-razor@blackwall.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
This patch-set adds support to specify filtering conditions for a bulk
delete (flush) operation. This version uses a new nlmsghdr delete flag
called NLM_F_BULK in combination with a new ndo_fdb_del_bulk op which is
used to signal that the driver supports bulk deletes (that avoids
pushing common mac address checks to ndo_fdb_del implementations and
also has a different prototype and parsed attribute expectations, more
info in patch 03). The new delete flag can be used for any RTM_DEL*
type, implementations just need to be careful with older kernels which
are doing non-strict attribute parses. Here I use the fact that mac
address attribute (lladdr) is mandatory in the classic fdb del case, but
it's not allowed if bulk deleting so older kernels will error out.
Patch 01 adds the new NLM_F_BULK delete request modifier, patch 02 then
adds the new ndo_fdb_del_bulk call. Patch 03 adds NLM_F_BULK support to
rtnl_fdb_del, on such request strict parsing is used only for the
supported attributes, and if the ndo is implemented it's called, the
NTF_SELF/MASTER rules are the same as for the standard rtnl_fdb_del.
Patch 04 implements bridge-specific minimal ndo_fdb_del_bulk call which
uses the current br_fdb_flush to delete all entries. Patch 05 adds
filtering support to the new bridge flush op which supports target
ifindex (port or bridge), vlan id and flags/state mask. Patch 06 adds
ndm state and flags mask attributes which will be used for filtering.
Patch 07 converts ndm state/flags and their masks to bridge-private flags
and fills them in the filter descriptor for matching. Finally patch 08
fills in the target ifindex (after validating it) and vlan id (already
validated by rtnl_fdb_flush) for matching. Flush filtering is needed
because user-space applications need a quick way to delete only a
specific set of entries, e.g. mlag implementations need a way to flush only
dynamic entries excluding externally learned ones or only externally
learned ones without static entries etc. Also apps usually want to target
only a specific vlan or port/vlan combination. The current 2 flush
operations (per port and bridge-wide) are not extensible and cannot
provide such filtering.

I decided against embedding new attrs into the old flush attributes for
multiple reasons - proper error handling on unsupported attributes,
older kernels silently flushing all, need for a second mechanism to
signal that the attribute should be parsed (e.g. using boolopts),
special treatment for permanent entries.

Examples:
$ bridge fdb flush dev bridge vlan 100 static
< flush all static entries on vlan 100 >
$ bridge fdb flush dev bridge vlan 1 dynamic
< flush all dynamic entries on vlan 1 >
$ bridge fdb flush dev bridge port ens16 vlan 1 dynamic
< flush all dynamic entries on port ens16 and vlan 1 >
$ bridge fdb flush dev ens16 vlan 1 dynamic master
< as above: flush all dynamic entries on port ens16 and vlan 1 >
$ bridge fdb flush dev bridge nooffloaded nopermanent self
< flush all non-offloaded and non-permanent entries >
$ bridge fdb flush dev bridge static noextern_learn
< flush all static entries which are not externally learned >
$ bridge fdb flush dev bridge permanent
< flush all permanent entries >
$ bridge fdb flush dev bridge port bridge permanent
< flush all permanent entries pointing to the bridge itself >

Example of a flush call with unsupported netlink attribute (NDA_DST):
$ bridge fdb flush dev bridge vlan 100 dynamic dst
Error: Unsupported attribute.

Example of a flush call on an older kernel:
$ bridge fdb flush dev bridge dynamic
Error: invalid address.

Note that all flags have their negated version (static vs nostatic etc)
and there are some tricky cases to handle like "static" which in flag
terms means fdbs that have NUD_NOARP but *not* NUD_PERMANENT, so the
mask matches on both but we need only NUD_NOARP to be set. That's
because permanent entries have both set so we can't just match on
NUD_NOARP. Also note that this flush operation doesn't treat permanent
entries in a special way (fdb_delete vs fdb_delete_local), it will
delete them regardless if any port is using them. We can extend the api
with a flag to do that if needed in the future.

Patch-sets (in order):
 - Initial flush infra and fdb flush filtering (this set)
 - iproute2 support
 - selftests

Future work:
 - mdb flush support (RTM_FLUSHMDB type)

Thanks to Ido for the great discussion and feedback while working on this.

v3: Add NLM_F_BULK delete modifier and ndo_fdb_del_bulk callback,
    patches 01 - 03 and 06 are new. Patch 04 is changed to implement
    bulk_del instead of flush, patches 05, 07 and 08 are adjusted to
    use NDA_ attributes

Thanks,
 Nik

Nikolay Aleksandrov (8):
  net: netlink: add NLM_F_BULK delete request modifier
  net: add ndo_fdb_del_bulk
  net: rtnetlink: add NLM_F_BULK support to rtnl_fdb_del
  net: bridge: fdb: add ndo_fdb_del_bulk
  net: bridge: fdb: add support for fine-grained flushing
  net: rtnetlink: add ndm flags and state mask attributes
  net: bridge: fdb: add support for flush filtering based on ndm flags
    and state
  net: bridge: fdb: add support for flush filtering based on ifindex and
    vlan

 include/linux/netdevice.h      |   9 ++
 include/uapi/linux/neighbour.h |   2 +
 include/uapi/linux/netlink.h   |   1 +
 net/bridge/br_device.c         |   1 +
 net/bridge/br_fdb.c            | 154 +++++++++++++++++++++++++++++++--
 net/bridge/br_netlink.c        |   9 +-
 net/bridge/br_private.h        |  19 +++-
 net/bridge/br_sysfs_br.c       |   6 +-
 net/core/rtnetlink.c           |  66 ++++++++++----
 9 files changed, 238 insertions(+), 29 deletions(-)

-- 
2.35.1

