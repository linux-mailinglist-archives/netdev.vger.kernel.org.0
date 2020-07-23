Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDC222BA36
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 01:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgGWX1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 19:27:00 -0400
Received: from foss.arm.com ([217.140.110.172]:53008 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726657AbgGWX07 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 19:26:59 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C619830E;
        Thu, 23 Jul 2020 16:26:58 -0700 (PDT)
Received: from [192.168.122.166] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5B7223F718;
        Thu, 23 Jul 2020 16:26:58 -0700 (PDT)
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO
 PHY
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Cc:     netdev@vger.kernel.org, linux.cj@gmail.com,
        linux-acpi@vger.kernel.org
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <1a031e62-1e87-fdc1-b672-e3ccf3530fda@arm.com>
Date:   Thu, 23 Jul 2020 18:26:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200715090400.4733-2-calvin.johnson@oss.nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 7/15/20 4:03 AM, Calvin Johnson wrote:
> Introduce ACPI mechanism to get PHYs registered on a MDIO bus and
> provide them to be connected to MAC.
> 
> An ACPI node property "mdio-handle" is introduced to reference the
> MDIO bus on which PHYs are registered with autoprobing method used
> by mdiobus_register().
> 
> Describe properties "phy-channel" and "phy-mode"
> 
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> 
> ---
> 
> Changes in v7: None
> Changes in v6: None
> Changes in v5: None
> Changes in v4: None
> Changes in v3:
> - cleanup based on v2 comments
> - Added description for more properties
> - Added MDIO node DSDT entry
> 
> Changes in v2: None
> 
>   Documentation/firmware-guide/acpi/dsd/phy.rst | 90 +++++++++++++++++++
>   1 file changed, 90 insertions(+)
>   create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst
> 
> diff --git a/Documentation/firmware-guide/acpi/dsd/phy.rst b/Documentation/firmware-guide/acpi/dsd/phy.rst
> new file mode 100644
> index 000000000000..0132fee10b45
> --- /dev/null
> +++ b/Documentation/firmware-guide/acpi/dsd/phy.rst
> @@ -0,0 +1,90 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=========================
> +MDIO bus and PHYs in ACPI
> +=========================
> +
> +The PHYs on an mdiobus are probed and registered using mdiobus_register().
> +Later, for connecting these PHYs to MAC, the PHYs registered on the
> +mdiobus have to be referenced.

First, this is all perfectly compatible with my literal interpretation 
and understanding of the ACPI spec. The use of _DSD is there to provide 
a way to "extend" if you will the specification for device specific edge 
cases that aren't directly covered by the spec.

OTOH, it may be my lack of knowledge here, but IMHO this is a bit of a 
difficult pill for all arm/sbsa systems though. Primary because I don't 
see how one is expected to use the generic ACPI power states on the 
parent device here. I also have some questions about how one might 
import such a device into a VM. Further AFAIK arm's current 
recommendations for SBSA/ACPI systems point in the direction of RCiEP's.

IMHO what should be clarified in this document is something to the 
effect that the "mdio-handle" is used for systems which have multiple 
nic/mac's sharing a single MDIO bus. Otherwise the MDIO bus and its phy 
should be a child of the nic/mac using it, with standardized 
behaviors/etc left up to the OSPM when it comes to MDIO bus 
enumeration/etc.

Thanks,


> +
> +mdio-handle
> +-----------
> +For each MAC node, a property "mdio-handle" is used to reference the
> +MDIO bus on which the PHYs are registered. On getting hold of the MDIO
> +bus, use find_phy_device() to get the PHY connected to the MAC.
> +
> +phy-channel
> +-----------
> +Property "phy-channel" defines the address of the PHY on the mdiobus.
> +
> +phy-mode
> +--------
> +Property "phy-mode" defines the type of PHY interface.
> +
> +An example of this is shown below::
> +
> +DSDT entry for MAC where MDIO node is referenced
> +------------------------------------------------
> +	Scope(\_SB.MCE0.PR17) // 1G
> +	{
> +	  Name (_DSD, Package () {
> +	     ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> +		 Package () {
> +		     Package () {"phy-channel", 1},
> +		     Package () {"phy-mode", "rgmii-id"},
> +		     Package () {"mdio-handle", Package (){\_SB.MDI0}}
> +	      }
> +	   })
> +	}
> +
> +	Scope(\_SB.MCE0.PR18) // 1G
> +	{
> +	  Name (_DSD, Package () {
> +	    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> +		Package () {
> +		    Package () {"phy-channel", 2},
> +		    Package () {"phy-mode", "rgmii-id"},
> +		    Package () {"mdio-handle", Package (){\_SB.MDI0}}
> +	    }
> +	  })
> +	}
> +
> +DSDT entry for MDIO node
> +------------------------
> +a) Silicon Component
> +--------------------
> +	Scope(_SB)
> +	{
> +	  Device(MDI0) {
> +	    Name(_HID, "NXP0006")
> +	    Name(_CCA, 1)
> +	    Name(_UID, 0)
> +	    Name(_CRS, ResourceTemplate() {
> +	      Memory32Fixed(ReadWrite, MDI0_BASE, MDI_LEN)
> +	      Interrupt(ResourceConsumer, Level, ActiveHigh, Shared)
> +	       {
> +		 MDI0_IT
> +	       }
> +	    }) // end of _CRS for MDI0
> +	    Name (_DSD, Package () {
> +	      ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> +	      Package () {
> +		 Package () {"little-endian", 1},
> +	      }
> +	    })
> +	  } // end of MDI0
> +	}
> +
> +b) Platform Component
> +---------------------
> +	Scope(\_SB.MDI0)
> +	{
> +	  Device(PHY1) {
> +	    Name (_ADR, 0x1)
> +	  } // end of PHY1
> +
> +	  Device(PHY2) {
> +	    Name (_ADR, 0x2)
> +	  } // end of PHY2
> +	}
> 

