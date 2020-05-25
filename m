Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32231E0A77
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 11:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389448AbgEYJ2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 05:28:55 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:48362 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389330AbgEYJ2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 05:28:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1590398934; x=1621934934;
  h=date:from:to:subject:message-id:mime-version;
  bh=uIfaX+EQPpYkQ3H7bVFuEEKfX/tCjxDONoYFIwtAJpk=;
  b=XuIA6QPiFQzLre4Y9H84tU7z24o6fQGtPDOx0cURrP6TEua5/0uanO3+
   QMNPvXtplHCFvTutj+W9N0V3mtmKW25yqyExZbM0BsuSpCUE1IFOWsZ8r
   Q34DOYwCwE/YsUHSmYQZkxTF4hVg+h9X2KSxkdPeutjpSghJ/XQKYbVEM
   vDE+4QuHbYJls/czTpMKWkk+gJ72Wnik8yIzjqYlQybwg3gV4GhGT1YVv
   TZBSO4MpwphYUXsyZJb0nGFq0Iuuq8g5334wvL8CUqEoW6/ALuwpl/ClS
   55owo4jA2qhZGqpCjMcSTfWJxWlDawFqfyNGNXHg67L4H87oDjNFKXfAi
   w==;
IronPort-SDR: JjNAMYcmRpZ/Bc0iYhVo/n47uwehIHE6TJ9Uojq9rvVkZInGYF1YH1S7oZJJ/lv+84dqd7Efcj
 zBXBI3M2SSwSdL5tQmDJFKsGX3fkVwZhxaYds6dSvTONT6tisASBHkAh3IODgdmB4dYFU8Dy4r
 YVYVrNhHkYy/QSanww25b26atIHy0Chd1yPW3bdLoWx/S1wwOflgJDJ7ERaGBZztH8slNIJMff
 cwc8laMwE0U1zDaWZAqeBcl+qIcUI6OXou8GWVS2nVDzB5kh1TH23B2AU9V8TwmUwHsWJni5qZ
 +zk=
X-IronPort-AV: E=Sophos;i="5.73,433,1583218800"; 
   d="scan'208";a="76274503"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 May 2020 02:28:53 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 25 May 2020 02:28:53 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Mon, 25 May 2020 02:28:53 -0700
Date:   Mon, 25 May 2020 11:28:27 +0000
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: MRP netlink interface
Message-ID: <20200525112827.t4nf4lamz6g4g2c5@soft-dev3.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

While I was working on adding support for MRA role to MRP, I noticed that I
might have some issues with the netlink interface, so it would be great if you
can give me an advice on how to continue.

First a node with MRA role can behave as a MRM(Manager) or as a
MRC(Client). The behaviour is decided by the priority of each node. So
to have this functionality I have to extend the MRP netlink interface
and this brings me to my issues.

My first approach was to extend the 'struct br_mrp_instance' with a field that
contains the priority of the node. But this breaks the backwards compatibility,
and then every time when I need to change something, I will break the backwards
compatibility. Is this a way to go forward?

Another approach is to restructure MRP netlink interface. What I was thinking to
keep the current attributes (IFLA_BRIDGE_MRP_INSTANCE,
IFLA_BRIDGE_MRP_PORT_STATE,...) but they will be nested attributes and each of
this attribute to contain the fields of the structures they represents.
For example:
[IFLA_AF_SPEC] = {
    [IFLA_BRIDGE_FLAGS]
    [IFLA_BRIDGE_MRP]
        [IFLA_BRIDGE_MRP_INSTANCE]
            [IFLA_BRIDGE_MRP_INSTANCE_RING_ID]
            [IFLA_BRIDGE_MRP_INSTANCE_P_IFINDEX]
            [IFLA_BRIDGE_MRP_INSTANCE_S_IFINDEX]
        [IFLA_BRIDGE_MRP_RING_ROLE]
            [IFLA_BRIDGE_MRP_RING_ROLE_RING_ID]
            [IFLA_BRIDGE_MRP_RING_ROLE_ROLE]
        ...
}
And then I can parse each field separately and then fill up the structure
(br_mrp_instance, br_mrp_port_role, ...) which will be used forward.
Then when this needs to be extended with the priority it would have the
following format:
[IFLA_AF_SPEC] = {
    [IFLA_BRIDGE_FLAGS]
    [IFLA_BRIDGE_MRP]
        [IFLA_BRIDGE_MRP_INSTANCE]
            [IFLA_BRIDGE_MRP_INSTANCE_RING_ID]
            [IFLA_BRIDGE_MRP_INSTANCE_P_IFINDEX]
            [IFLA_BRIDGE_MRP_INSTANCE_S_IFINDEX]
            [IFLA_BRIDGE_MRP_INSTANCE_PRIO]
        [IFLA_BRIDGE_MRP_RING_ROLE]
            [IFLA_BRIDGE_MRP_RING_ROLE_RING_ID]
            [IFLA_BRIDGE_MRP_RING_ROLE_ROLE]
        ...
}
And also the br_mrp_instance will have a field called prio.
So now, if the userspace is not updated to have support for setting the prio
then the kernel will use a default value. Then if the userspace contains a field
that the kernel doesn't know about, then it would just ignore it.
So in this way every time when the netlink interface will be extended it would
be backwards compatible.

If it is not possible to break the compatibility then the safest way is to
just add more attributes under IFLA_BRIDGE_MRP but this would just complicate
the kernel and the userspace and it would make it much harder to be extended in
the future.

My personal choice would be the second approach, even if it breaks the backwards
compatibility. Because it is the easier to go forward and there are only 3
people who cloned the userspace application
(https://github.com/microchip-ung/mrp/graphs/traffic). And two of
these unique cloners is me and Allan.

So if you have any advice on how to go forward it would be great.

-- 
/Horatiu
