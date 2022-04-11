Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 753B04FC370
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 19:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348953AbiDKRcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 13:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348951AbiDKRcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 13:32:17 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8782E080
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 10:29:58 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id bg10so32370208ejb.4
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 10:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5NzG0fXNVZBj/UDadtHbCpqi+f3GpVVf/AjDM2V657U=;
        b=luDisS4jErifzNx8Rvg2peH+azYdVxUq1TR7OUIZtboipk0l+N9gIyoc+kYdkSqPuw
         vz1OgGj/+rCESl/Risj9f/vhjAw0lDOkGtjEG1tokrdZw88t0ymqpiO+0R5aU4dXBkwf
         3ySkSp3GzvstOdWcEidm4jbS/2bh4hqVWpf4KvDLsluMcuVwluzLZfAsQCLI+GTjNGgk
         78Ibvqm/zEFV/d9Dht2sPqYeBDjqGBAKCwfXqrUWQHnd47seNGetRAA5q9GxFmINycZI
         Y6tF/CdmjqV9WorIrVKVVPpgody9CfjztuTeryrEFjqbepMjcdOWcZTT5vhMob3SVS+T
         i43g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5NzG0fXNVZBj/UDadtHbCpqi+f3GpVVf/AjDM2V657U=;
        b=R0/stZkd8sVJyN4OQGM15IVCvRSFJdaGKtLTPRVSd2g1K7klJVblMk/oARiTCTH9Sx
         JUPoDs7pFTytpK+dtaVEVmZYSgspeyNDStmOJXu9bduJ1LqAjBgpb/+at0Qzl9eQWGfI
         L1zq4/b7m2o9ypEFJ293N0OyVZNc2jU++jVK++e5wqilKIJAXslUJSIww3B989IA6v9L
         NPc+XhHoqPlQ/GIXHvpW+0NZcRktOyvahYElSPkyMBhfZqP8AqdlbhZocnh437YD+w0i
         sz301m2gSfma2k1bfKEayA8KyJoALlDzuhT7C3feJxZzwvg4ren+S0MkWUEQeA6QsBoo
         1dqQ==
X-Gm-Message-State: AOAM532R4CQ/zI0QjRHW2SLslTUZARooa5qiX0Syw0e5nd+kL6szr6cu
        lmh8PQAwuuozVe41VuqrjsxMb5GnfIa2WCo9
X-Google-Smtp-Source: ABdhPJzmoG2sHzgScaaZLbYVEJ4npFrmTRobPohk0MW3RI7wVCuRLBfUKhc+eOEXjNeRpQDRojXYTg==
X-Received: by 2002:a17:907:209c:b0:6e8:807c:cdf0 with SMTP id pv28-20020a170907209c00b006e8807ccdf0mr8226557ejb.256.1649698196345;
        Mon, 11 Apr 2022 10:29:56 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id u6-20020a17090626c600b006e74ef7f092sm10325084ejc.176.2022.04.11.10.29.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 10:29:55 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, idosch@idosch.org, kuba@kernel.org,
        davem@davemloft.net, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net-next v2 0/8] net: bridge: add flush filtering support
Date:   Mon, 11 Apr 2022 20:29:26 +0300
Message-Id: <20220411172934.1813604-1-razor@blackwall.org>
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
This patch-set adds support to specify filtering conditions for a flush
operation. This version has entirely different entry point (v1 had
bridge-specific IFLA attribute, here I add new RTM_FLUSHNEIGH msg and
netdev ndo_fdb_flush op) so I'll give a new overview altogether.
After me and Ido discussed the feature offlist, we agreed that it would
be best to add a new generic RTM_FLUSHNEIGH with a new ndo_fdb_flush
callback which can be re-used for other drivers (e.g. vxlan).
Patch 01 adds the new RTM_FLUSHNEIGH type, patch 02 then adds the
new ndo_fdb_flush call. With this structure we need to add a generic
rtnl_fdb_flush which will be used to do basic attribute validation and
dispatch the call to the appropriate device based on the NTF_USE/MASTER
flags (patch 03). Patch 04 then adds some common flush attributes which
are used by the bridge and vxlan drivers (target ifindex, vlan id, ndm
flags/state masks) with basic attribute validation, further validation
can be done by the implementers of the ndo callback. Patch 05 adds a
minimal ndo_fdb_flush to the bridge driver, it uses the current
br_fdb_flush implementation to flush all entries similar to existing
calls. Patch 06 adds filtering support to the new bridge flush op which
supports target ifindex (port or bridge), vlan id and flags/state mask.
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

Thanks,
 Nik

Nikolay Aleksandrov (8):
  net: rtnetlink: add RTM_FLUSHNEIGH
  net: add ndo_fdb_flush op
  net: bridge: fdb: add ndo_fdb_flush op
  net: rtnetlink: register a generic rtnl_fdb_flush call
  net: rtnetlink: add common flush attributes
  net: bridge: fdb: add support for fine-grained flushing
  net: bridge: fdb: add support for flush filtering based on ndm flags
    and state
  net: bridge: fdb: add support for flush filtering based on ifindex and
    vlan

 include/linux/netdevice.h      |  11 +++
 include/uapi/linux/neighbour.h |  10 +++
 include/uapi/linux/rtnetlink.h |   3 +
 net/bridge/br_device.c         |   1 +
 net/bridge/br_fdb.c            | 154 +++++++++++++++++++++++++++++++--
 net/bridge/br_netlink.c        |   9 +-
 net/bridge/br_private.h        |  19 +++-
 net/bridge/br_sysfs_br.c       |   6 +-
 net/core/rtnetlink.c           |  62 +++++++++++++
 security/selinux/nlmsgtab.c    |   3 +-
 10 files changed, 266 insertions(+), 12 deletions(-)

-- 
2.35.1

