Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62EF2452B94
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 08:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbhKPHdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 02:33:13 -0500
Received: from samsargika.copyninja.info ([146.185.137.224]:60124 "EHLO
        mail.copyninja.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbhKPHdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 02:33:12 -0500
X-Greylist: delayed 499 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Nov 2021 02:33:11 EST
Received: from localhost (localhost [127.0.0.1])
        by mail.copyninja.info (Postfix) with ESMTP id 4DE85C34C0;
        Tue, 16 Nov 2021 12:51:54 +0530 (IST)
Received: from mail.copyninja.info ([127.0.0.1])
        by localhost (localhost [127.0.0.1]) (amavisd-new, port 10024)
        with SMTP id XlSa4TVMz5Bj; Tue, 16 Nov 2021 12:51:53 +0530 (IST)
Received: from bhrigu.local (unknown [157.45.81.160])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mail.copyninja.info (Postfix) with ESMTPSA id 0110AC30C6;
        Tue, 16 Nov 2021 12:51:52 +0530 (IST)
Received: from bhrigu.local (localhost [IPv6:::1])
        by bhrigu.local (Postfix) with ESMTP id 9A8E58012D;
        Tue, 16 Nov 2021 12:51:50 +0530 (IST)
From:   Vasudev Kamath <vasudev@copyninja.info>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Krishna Kumar <krikku@gmail.com>,
        Vasudev Kamath <vasudev@copyninja.info>
Subject: [PATCH net-next] Documentation: networking: net_failover: Fix documentation
Date:   Tue, 16 Nov 2021 12:51:48 +0530
Message-Id: <20211116072148.2044042-1-vasudev@copyninja.info>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update net_failover documentation with missing and incomplete
details to get a proper working setup.

Signed-off-by: Vasudev Kamath <vasudev@copyninja.info>
Reviewed-by: Krishna Kumar <krikku@gmail.com>
---
 Documentation/networking/net_failover.rst | 111 +++++++++++++++++-----
 1 file changed, 88 insertions(+), 23 deletions(-)

diff --git a/Documentation/networking/net_failover.rst b/Documentation/ne=
tworking/net_failover.rst
index e143ab79a960..3a662f2b4d6e 100644
--- a/Documentation/networking/net_failover.rst
+++ b/Documentation/networking/net_failover.rst
@@ -35,7 +35,7 @@ To support this, the hypervisor needs to enable VIRTIO_=
NET_F_STANDBY
 feature on the virtio-net interface and assign the same MAC address to b=
oth
 virtio-net and VF interfaces.
=20
-Here is an example XML snippet that shows such configuration.
+Here is an example libvirt XML snippet that shows such configuration:
 ::
=20
   <interface type=3D'network'>
@@ -45,18 +45,32 @@ Here is an example XML snippet that shows such config=
uration.
     <model type=3D'virtio'/>
     <driver name=3D'vhost' queues=3D'4'/>
     <link state=3D'down'/>
-    <address type=3D'pci' domain=3D'0x0000' bus=3D'0x00' slot=3D'0x0a' f=
unction=3D'0x0'/>
+    <teaming type=3D'persistent'/>
+    <alias name=3D'ua-backup0'/>
   </interface>
   <interface type=3D'hostdev' managed=3D'yes'>
     <mac address=3D'52:54:00:00:12:53'/>
     <source>
       <address type=3D'pci' domain=3D'0x0000' bus=3D'0x42' slot=3D'0x02'=
 function=3D'0x5'/>
     </source>
-    <address type=3D'pci' domain=3D'0x0000' bus=3D'0x00' slot=3D'0x0b' f=
unction=3D'0x0'/>
+    <teaming type=3D'transient' persistent=3D'ua-backup0'/>
   </interface>
=20
+In this configuration, the first device definition is for the virtio-net
+interface and this acts as the 'persistent' device indicating that this
+interface will always be plugged in. This is specified by the 'teaming' =
tag with
+required attribute type having value 'persistent'. The link state for th=
e
+virtio-net device is set to 'down' to ensure that the 'failover' netdev =
prefers
+the VF passthrough device for normal communication. The virtio-net devic=
e will
+be brought UP during live migration to allow uninterrupted communication=
.
+
+The second device definition is for the VF passthrough interface. Here t=
he
+'teaming' tag is provided with type 'transient' indicating that this dev=
ice may
+periodically be unplugged. A second attribute - 'persistent' is provided=
 and
+points to the alias name declared for the virtio-net device.
+
 Booting a VM with the above configuration will result in the following 3
-netdevs created in the VM.
+interfaces created in the VM:
 ::
=20
   4: ens10: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue sta=
te UP group default qlen 1000
@@ -65,13 +79,36 @@ netdevs created in the VM.
          valid_lft 42482sec preferred_lft 42482sec
       inet6 fe80::97d8:db2:8c10:b6d6/64 scope link
          valid_lft forever preferred_lft forever
-  5: ens10nsby: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_code=
l master ens10 state UP group default qlen 1000
+  5: ens10nsby: <BROADCAST,MULTICAST> mtu 1500 qdisc fq_codel master ens=
10 state DOWN group default qlen 1000
       link/ether 52:54:00:00:12:53 brd ff:ff:ff:ff:ff:ff
   7: ens11: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master e=
ns10 state UP group default qlen 1000
       link/ether 52:54:00:00:12:53 brd ff:ff:ff:ff:ff:ff
=20
-ens10 is the 'failover' master netdev, ens10nsby and ens11 are the slave
-'standby' and 'primary' netdevs respectively.
+Here, ens10 is the 'failover' master interface, ens10nsby is the slave '=
standby'
+virtio-net interface, and ens11 is the slave 'primary' VF passthrough in=
terface.
+
+One point to note here is that some user space network configuration dae=
mons
+like systemd-networkd, ifupdown, etc, do not understand the 'net_failove=
r'
+device; and on the first boot, the VM might end up with both 'failover' =
device
+and VF accquiring IP addresses (either same or different) from the DHCP =
server.
+This will result in lack of connectivity to the VM. So some tweaks might=
 be
+needed to these network configuration daemons to make sure that an IP is
+received only on the 'failover' device.
+
+Below is the patch snippet used with 'cloud-ifupdown-helper' script foun=
d on
+Debian cloud images:
+
+::
+  @@ -27,6 +27,8 @@ do_setup() {
+       local working=3D"$cfgdir/.$INTERFACE"
+       local final=3D"$cfgdir/$INTERFACE"
+
+  +    if [ -d "/sys/class/net/${INTERFACE}/master" ]; then exit 0; fi
+  +
+       if ifup --no-act "$INTERFACE" > /dev/null 2>&1; then
+           # interface is already known to ifupdown, no need to generate=
 cfg
+           log "Skipping configuration generation for $INTERFACE"
+
=20
 Live Migration of a VM with SR-IOV VF & virtio-net in STANDBY mode
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
@@ -80,40 +117,68 @@ net_failover also enables hypervisor controlled live=
 migration to be supported
 with VMs that have direct attached SR-IOV VF devices by automatic failov=
er to
 the paravirtual datapath when the VF is unplugged.
=20
-Here is a sample script that shows the steps to initiate live migration =
on
-the source hypervisor.
+Here is a sample script that shows the steps to initiate live migration =
from
+the source hypervisor. Note: It is assumed that the VM is connected to a
+software bridge 'br0' which has a single VF attached to it along with th=
e vnet
+device to the VM. This is not the VF that was passthrough'd to the VM (s=
een in
+the vf.xml file).
 ::
=20
-  # cat vf_xml
+  # cat vf.xml
   <interface type=3D'hostdev' managed=3D'yes'>
     <mac address=3D'52:54:00:00:12:53'/>
     <source>
       <address type=3D'pci' domain=3D'0x0000' bus=3D'0x42' slot=3D'0x02'=
 function=3D'0x5'/>
     </source>
-    <address type=3D'pci' domain=3D'0x0000' bus=3D'0x00' slot=3D'0x0b' f=
unction=3D'0x0'/>
+    <teaming type=3D'transient' persistent=3D'ua-backup0'/>
   </interface>
=20
-  # Source Hypervisor
+  # Source Hypervisor migrate.sh
   #!/bin/bash
=20
-  DOMAIN=3Dfedora27-tap01
-  PF=3Denp66s0f0
-  VF_NUM=3D5
-  TAP_IF=3Dtap01
-  VF_XML=3D
+  DOMAIN=3Dvm-01
+  PF=3Dens6np0
+  VF=3Dens6v1             # VF attached to the bridge.
+  VF_NUM=3D1
+  TAP_IF=3Dvmtap01        # virtio-net interface in the VM.
+  VF_XML=3Dvf.xml
=20
   MAC=3D52:54:00:00:12:53
   ZERO_MAC=3D00:00:00:00:00:00
=20
+  # Set the virtio-net interface up.
   virsh domif-setlink $DOMAIN $TAP_IF up
-  bridge fdb del $MAC dev $PF master
-  virsh detach-device $DOMAIN $VF_XML
+
+  # Remove the VF that was passthrough'd to the VM.
+  virsh detach-device --live --config $DOMAIN $VF_XML
+
   ip link set $PF vf $VF_NUM mac $ZERO_MAC
=20
-  virsh migrate --live $DOMAIN qemu+ssh://$REMOTE_HOST/system
+  # Add FDB entry for traffic to continue going to the VM via
+  # the VF -> br0 -> vnet interface path.
+  bridge fdb add $MAC dev $VF
+  bridge fdb add $MAC dev $TAP_IF master
+
+  # Migrate the VM
+  virsh migrate --live --persistent $DOMAIN qemu+ssh://$REMOTE_HOST/syst=
em
+
+  # Clean up FDB entries after migration completes.
+  bridge fdb del $MAC dev $VF
+  bridge fdb del $MAC dev $TAP_IF master
=20
-  # Destination Hypervisor
+On the destination hypervisor, a shared bridge 'br0' is created before m=
igration
+starts, and a VF from the destination PF is added to the bridge. Similar=
ly an
+appropriate FDB entry is added.
+
+The following script is executed on the destination hypervisor once migr=
ation
+completes, and it reattaches the VF to the VM and brings down the virtio=
-net
+interface.
+
+::
+  # reattach-vf.sh
   #!/bin/bash
=20
-  virsh attach-device $DOMAIN $VF_XML
-  virsh domif-setlink $DOMAIN $TAP_IF down
+  bridge fdb del 52:54:00:00:12:53 dev ens36v0
+  bridge fdb del 52:54:00:00:12:53 dev vmtap01 master
+  virsh attach-device --config --live vm01 vf.xml
+  virsh domif-setlink vm01 vmtap01 down
--=20
2.33.1

