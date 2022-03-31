Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD884EDDDB
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 17:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238833AbiCaPu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 11:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238310AbiCaPu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 11:50:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E33496452
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 08:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648741720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4AfbyPy4SWzRXPVjHP0oBQj2Lh8yjlIRr7X3xHwYmlQ=;
        b=itPADY+00zFMgUoyrmBduUN3mOuaxgYUSwyZn/qHR6e7caccRD3tiRYxmAcEnxNY86Z7pg
        uM+VOO7kZAwyAGYQoEE79Ko99DDWsuJdAUxL3ruWfrD6rlt5fXtt8/BotvRu12c+DoJGqh
        aqsWrFDNf/G16jfC3sJaTFEOBuhdNzk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-640-M8hUdgw9N_e9gs5xMqi0OA-1; Thu, 31 Mar 2022 11:48:36 -0400
X-MC-Unique: M8hUdgw9N_e9gs5xMqi0OA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E4FC9185A79C;
        Thu, 31 Mar 2022 15:48:35 +0000 (UTC)
Received: from ceranb (unknown [10.40.192.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 680862157F29;
        Thu, 31 Mar 2022 15:48:33 +0000 (UTC)
Date:   Thu, 31 Mar 2022 17:48:32 +0200
From:   Ivan Vecera <ivecera@redhat.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     netdev@vger.kernel.org,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>, mschmidt@redhat.com,
        Brett Creeley <brett.creeley@intel.com>,
        open list <linux-kernel@vger.kernel.org>, poros@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [Intel-wired-lan] [PATCH net] ice: Fix incorrect locking in
 ice_vc_process_vf_msg()
Message-ID: <20220331174832.68e17c4a@ceranb>
In-Reply-To: <YkWpNVXYEBo/u3dm@boxer>
References: <20220331105005.2580771-1-ivecera@redhat.com>
        <YkWpNVXYEBo/u3dm@boxer>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 31 Mar 2022 15:14:29 +0200
Maciej Fijalkowski <maciej.fijalkowski@intel.com> wrote:

> On Thu, Mar 31, 2022 at 12:50:04PM +0200, Ivan Vecera wrote:
> > Usage of mutex_trylock() in ice_vc_process_vf_msg() is incorrect
> > because message sent from VF is ignored and never processed.
> >=20
> > Use mutex_lock() instead to fix the issue. It is safe because this =20
>=20
> We need to know what is *the* issue in the first place.
> Could you please provide more context what is being fixed to the readers
> that don't have an access to bugzilla?
>=20
> Specifically, what is the case that ignoring a particular message when
> mutex is already held is a broken behavior?

Reproducer:

<code>
#!/bin/sh

set -xe

PF=3D"ens7f0"
VF=3D"${PF}v0"

echo 1 > /sys/class/net/${PF}/device/sriov_numvfs
sleep 2

ip link set ${VF} up
ip addr add 172.30.29.11/24 dev ${VF}

while true; do

# Set VF to be trusted
ip link set ${PF} vf 0 trust on

# Ping server again
ping -c5 172.30.29.2 || {
        echo Ping failed
        ip link show dev ${VF} # <- No carrier here
        break
}

ip link set ${PF} vf 0 trust off
sleep 1

done

echo 0 > /sys/class/net/${PF}/device/sriov_numvfs
</code>

<sample>
[root@wsfd-advnetlab150 ~]# uname -r
5.17.0+ # Current net.git HEAD
[root@wsfd-advnetlab150 ~]# ./repro_simple.sh=20
+ PF=3Dens7f0
+ VF=3Dens7f0v0
+ echo 1
+ sleep 2
+ ip link set ens7f0v0 up
+ ip addr add 172.30.29.11/24 dev ens7f0v0
+ true
+ ip link set ens7f0 vf 0 trust on
+ ping -c5 172.30.29.2
PING 172.30.29.2 (172.30.29.2) 56(84) bytes of data.
64 bytes from 172.30.29.2: icmp_seq=3D2 ttl=3D64 time=3D0.820 ms
64 bytes from 172.30.29.2: icmp_seq=3D3 ttl=3D64 time=3D0.142 ms
64 bytes from 172.30.29.2: icmp_seq=3D4 ttl=3D64 time=3D0.128 ms
64 bytes from 172.30.29.2: icmp_seq=3D5 ttl=3D64 time=3D0.129 ms

--- 172.30.29.2 ping statistics ---
5 packets transmitted, 4 received, 20% packet loss, time 4110ms
rtt min/avg/max/mdev =3D 0.128/0.304/0.820/0.298 ms
+ ip link set ens7f0 vf 0 trust off
+ sleep 1
+ true
+ ip link set ens7f0 vf 0 trust on
+ ping -c5 172.30.29.2
PING 172.30.29.2 (172.30.29.2) 56(84) bytes of data.
=46rom 172.30.29.11 icmp_seq=3D1 Destination Host Unreachable
=46rom 172.30.29.11 icmp_seq=3D2 Destination Host Unreachable
=46rom 172.30.29.11 icmp_seq=3D3 Destination Host Unreachable

--- 172.30.29.2 ping statistics ---
5 packets transmitted, 0 received, +3 errors, 100% packet loss, time 4125ms
pipe 3
+ echo Ping failed
Ping failed
+ ip link show dev ens7f0v0
20: ens7f0v0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state D=
OWN mode DEFAULT group default qlen 1000
    link/ether de:69:e3:a5:68:b6 brd ff:ff:ff:ff:ff:ff
    altname enp202s0f0v0
+ break
+ echo 0

[root@wsfd-advnetlab150 ~]# dmesg | tail -8
[  220.265891] iavf 0000:ca:01.0: Reset indication received from the PF
[  220.272250] iavf 0000:ca:01.0: Scheduling reset task
[  220.277217] iavf 0000:ca:01.0: Hardware reset detected
[  220.292854] ice 0000:ca:00.0: VF 0 is now trusted
[  220.295027] ice 0000:ca:00.0: VF 0 is being configured in another contex=
t that will trigger a VFR, so there is no need to handle this message
[  234.445819] iavf 0000:ca:01.0: PF returned error -64 (IAVF_NOT_SUPPORTED=
) to our request 9
[  234.466827] iavf 0000:ca:01.0: Failed to delete MAC filter, error IAVF_N=
OT_SUPPORTED
[  234.474574] iavf 0000:ca:01.0: Remove device
</sample>

User set VF to be trusted so .ndo_set_vf_trust (ice_set_vf_trust) is called.
Function ice_set_vf_trust() takes vf->cfg_lock and calls ice_vc_reset_vf() =
that
sends message to iavf that initiates reset task. During this reset task iav=
f sends
config messages to ice. These messages are handled in ice_service_task() co=
ntext
via ice_clean_adminq_subtask() -> __ice_clean_ctrlq() -> ice_vc_process_vf_=
msg().

Function ice_vc_process_vf_msg() tries to take vf->cfg_lock but this can be=
 locked
from ice_set_vf_trust() yet (as in sample above). The lock attempt failed s=
o the function
returns, message is not processed.

Thanks,
Ivan

