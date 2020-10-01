Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0547927F991
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 08:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730555AbgJAGkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 02:40:07 -0400
Received: from lan.nucleusys.com ([92.247.61.126]:60856 "EHLO
        zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725878AbgJAGkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 02:40:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=nucleusys.com; s=x; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xq+1lYeJsOFsQQ4T49mj0SLF/Sem91VXNGyJ5ZWVyCs=; b=G8Z1g0ufi4vyH6Hn6c8L3m3pQ4
        gwuA033woo/FYOrpv8JGz6CRSkNmzdFsONZFyd9jpnpI4ZgbI3L7NMr3Z7olkgz66T6TZYOXlDkov
        lEPXJhz0KqcHcepM7SVmO4SwEdzYhwNUuagalPCatvFVIvK4OJM9LfOX+aQI32VxCnGI=;
Received: from [94.26.108.4] (helo=carbon)
        by zztop.nucleusys.com with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <petkan@nucleusys.com>)
        id 1kNsG0-00055f-BF; Thu, 01 Oct 2020 09:40:00 +0300
Date:   Thu, 1 Oct 2020 09:39:59 +0300
From:   Petko Manolov <petkan@nucleusys.com>
To:     David Bilsby <d.bilsby@virgin.net>
Cc:     Thor Thayer <thor.thayer@linux.intel.com>, netdev@vger.kernel.org
Subject: Re: Altera TSE driver not working in 100mbps mode
Message-ID: <20201001063959.GA8609@carbon>
Mail-Followup-To: David Bilsby <d.bilsby@virgin.net>,
        Thor Thayer <thor.thayer@linux.intel.com>, netdev@vger.kernel.org
References: <20191127135419.7r53qw6vtp747x62@p310>
 <20191203092918.52x3dfuvnryr5kpx@carbon>
 <c8e4fc3a-0f40-45b6-d9c8-f292c3fdec9d@virgin.net>
 <20200917064239.GA40050@p310>
 <9f312748-1069-4a30-ba3f-d1de6d84e920@virgin.net>
 <20200918171440.GA1538@p310>
 <bbd5cc3a-51a9-d46c-ef24-f0bb4d6498fe@virgin.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bbd5cc3a-51a9-d46c-ef24-f0bb4d6498fe@virgin.net>
X-Spam-Score: -1.0 (-)
X-Spam-Report: Spam detection software, running on the system "zztop.nucleusys.com",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 Content preview:  On 20-09-30 21:43:04, David Bilsby wrote: > > I've made some
    progress in integrating your TSE patches, in between doing my > main work.
    I've managed to get the code into the later 5.4.44 kernel and > [...] 
 Content analysis details:   (-1.0 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On 20-09-30 21:43:04, David Bilsby wrote:
> 
> I've made some progress in integrating your TSE patches, in between doing my
> main work. I've managed to get the code into the later 5.4.44 kernel and
> compile without errors, however my initial attempts failed to configure the
> driver. In case it was due to the kernel port I backed out to my 4.19 kernel
> build and used your patches as is. This also failed but after a bit of debug
> I realised it was just the device tree set up. I'm using the device tree as
> created by the sopc2dts tool, however this does not seem to create a "pcs"
> memory region in the TSEs iomem "reg" section. Did you add this section
> manually or was it created automatically from your sopcinfo file?

First off, it is recommended that you base your work on the latest kernel, 
unless the device you work on is stuck to an old one.  I can see that Altera TSE 
driver has received some attention recently so you should keep an eye on 
'netdev'.  Check the driver in v5.9 and, if possible, backport it to v5.4.

Second, PCS: in this particular design these registers were put at a specific 
location and that information went into the DT.  I had to add some glue code so 
the driver could receive these values and replace the defaults with.

> If you added this manually was it because the "pcs" regions location depends
> on the cores configuration, i.e. MAC and PCS or just PCS, and therefore it
> was easier to pass this into the driver through the device tree? The

Yup.

> firmware manual suggests that for a MAC with PCS core configuration the MAC
> registers appears at offset 0x0 for 0x80 and then the PCS registers from
> 0x80 for 0x20. I manually edited my device tree to shrink the default
> "control_port" region, which seems to map in the driver to the MAC config

These are implementation specific.  Don't forget you're on FPGA device, which 
allows for a lot of flexibility - memory region address and size shifts, 32 vs 
16 bit wide memory, etc.  You have to take into account both, TSE's manual as 
well as the actual implementation docs.

> registers and then added the "pcs" region above this. Once I'd done that the
> driver loaded successfully. I suspect if I make this change to the 5.4.44
> kernel version it will also initialise the driver.
> 
> I now seem to be tantalisingly close to getting it working. I can see
> network packets arriving if I do a "tcpdump -i eth0" using a copper
> 10/100/1000Base-T SFP, but no packets seem to be transmitted. I'm guessing
> I've maybe messed up on the device tree entries for either the SFP config or
> maybe how it links back to the TSE. In the TSE device tree section I added
> the following as suggested by your original post:
> 
>         sfp = <&sfp_eth_b>;
> 
>         managed = “in-band-status”;
> 
> Should I have added anything for the "phy-handle", thinks it's "<0>" at the
> moment?
> 
> For the SFP device tree section I added the following at the top level which
> broadly followed the "sff,sfp" document:
> 
> / {
> 
>     sfp_eth_b: sfp-eth-b {
> 
>         compatible = “sff,sfp”;
> 
>         i2c-bus = <sfp_b_i2c>;
> 
>         los-gpios = <&pca9506 10 GPIO_ACTIVE_HIGH>;
> 
>         …
> 
>     };
> 
> };

I've attached the .dtsi i used to hack on.  It most certainly won't work for 
your device, but you may get some inspiration.



		Petko


> The SFP cage is connected to the "sfp_b_i2c" I2C bus, this is actually off
> an I2C mux but that I'm hoping will be handled by Linux as it has a driver
> for the MUX chip. I assume the default SFP I2C address (0x50) is used by the
> PhyLink layer so there is no need to specify that? The LED indicators for my
> set up are off another I2C GPIO expander (PCA9506), so I used those
> references for the LOS, etc "gpios" entries. This section also has the
> "tx-disable-gpios" property, again I referenced the appropriate pin off the
> PCA9506, so I guess if I got that wrong then that could explain the failure
> on the Tx side. That said none of the LED GPIOs I hooked up seemed to light
> so maybe there is something up there.
> 
> Any hints would be most welcome.
> 
> Cheers
> 
> David
> 
> 
> 
> 

--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="petunia.dtsi"

/ {
	soc {
		ptp_clk: ptp_clk {
			status = "disabled";

			#clock-cells = <0>;
			compatible = "fixed-clock";
			clock-frequency = <50000000>;
		};

		phc_clock: phc_clock@c0707000 {
			compatible  = "petunia,oc4-phc";
			reg = <0xc0707000 0x8>;
			interrupt-parent =<&intc>;
			interrupts = <0 71 IRQ_TYPE_EDGE_RISING>;
		};

		spi_eeprom: spi@0xc0705000 {
			compatible = "altr,spi-1.0";
			reg = <0xc0705000 0x20>;
			interrupts = <0 69 4>;
			num-chipselect = <0x1>;
			status = "okay";
			#address-cells = <0x1>;
			#size-cells = <0x0>;

			at25@0 {
				compatible = "atmel,at25";
				reg = <0>;
				spi-max-frequency = <1000000>;
				pagesize = <32>;
				size = <8192>;
				address-width = <16>;
			};
		};

		tse_sub_0: ethernet@0xc0100000 {
			status = "disabled";

			compatible = "altr,tse-msgdma-1.0";
			reg =	<0xc0100000 0x00000400>,
				<0xc0101000 0x00000020>,
				<0xc0102000 0x00000020>,
				<0xc0103000 0x00000008>,
				<0xc0104000 0x00000020>,
				<0xc0105000 0x00000020>,
				<0xc0106000 0x00000100>;
			reg-names = "control_port", "rx_csr", "rx_desc", "rx_resp", "tx_csr", "tx_desc", "pcs";
			interrupt-parent =< &intc >;
			interrupts = <0 44 4>,<0 45 4>;
			interrupt-names = "rx_irq","tx_irq";
			rx-fifo-depth = <2048>;
			tx-fifo-depth = <2048>;
			address-bits = <48>;
			max-frame-size = <1500>;
			local-mac-address = [ 00 0C ED 00 00 02 ];
			altr,has-supplementary-unicast;
			altr,has-hash-multicast-filter;
			sfp = <&sfp0>;
			phy-mode = "sgmii";
			managed = "in-band-status";
		};

		tse_sub_1: ethernet@0xc0200000 {
			status = "disabled";

			compatible = "altr,tse-msgdma-1.0";
			reg =	<0xc0200000 0x00000400>,
				<0xc0201000 0x00000020>,
				<0xc0202000 0x00000020>,
				<0xc0203000 0x00000008>,
				<0xc0204000 0x00000020>,
				<0xc0205000 0x00000020>,
				<0xc0206000 0x00000100>;
			reg-names = "control_port", "rx_csr", "rx_desc", "rx_resp", "tx_csr", "tx_desc", "pcs";
			interrupt-parent =< &intc >;
			interrupts = <0 49 4>, <0 50 4>;
			interrupt-names = "rx_irq", "tx_irq";
			rx-fifo-depth = <2048>;
			tx-fifo-depth = <2048>;
			address-bits = <48>;
			max-frame-size = <1500>;
			local-mac-address = [ 00 0C ED 00 00 04 ];
			altr,has-supplementary-unicast;
			altr,has-hash-multicast-filter;
			sfp = <&sfp1>;
			phy-mode = "sgmii";
			managed = "in-band-status";
		};

		tse_sub_2: ethernet@0xc0300000 {
			status = "disabled";

			compatible = "altr,tse-msgdma-1.0";
			reg =	<0xc0300000 0x00000400>,
				<0xc0301000 0x00000020>,
				<0xc0302000 0x00000020>,
				<0xc0303000 0x00000008>,
				<0xc0304000 0x00000020>,
				<0xc0305000 0x00000020>,
				<0xc0306000 0x00000100>;
			reg-names = "control_port", "rx_csr", "rx_desc", "rx_resp", "tx_csr", "tx_desc", "pcs";
			interrupt-parent =< &intc >;
			interrupts = <0 54 4>, <0 55 4>;
			interrupt-names = "rx_irq", "tx_irq";
			rx-fifo-depth = <2048>;
			tx-fifo-depth = <2048>;
			address-bits = <48>;
			max-frame-size = <1500>;
			local-mac-address = [ 00 0C ED 00 00 06 ];
			altr,has-supplementary-unicast;
			altr,has-hash-multicast-filter;
			sfp = <&sfp2>;
			phy-mode = "sgmii";
			managed = "in-band-status";
		};

		tse_sub_3: ethernet@0xc0400000 {
			status = "disabled";

			compatible = "altr,tse-msgdma-1.0";
			reg =	<0xc0400000 0x00000400>,
				<0xc0401000 0x00000020>,
				<0xc0402000 0x00000020>,
				<0xc0403000 0x00000008>,
				<0xc0404000 0x00000020>,
				<0xc0405000 0x00000020>,
				<0xc0406000 0x00000100>;
			reg-names = "control_port", "rx_csr", "rx_desc", "rx_resp", "tx_csr", "tx_desc", "pcs";
			interrupt-parent =< &intc >;
			interrupts = <0 59 4>, <0 60 4>;
			interrupt-names = "rx_irq", "tx_irq";
			rx-fifo-depth = <2048>;
			tx-fifo-depth = <2048>;
			address-bits = <48>;
			max-frame-size = <1500>;
			local-mac-address = [ 00 0C ED 00 00 08 ];
			altr,has-supplementary-unicast;
			altr,has-hash-multicast-filter;
			sfp = <&sfp3>;
			phy-mode = "sgmii";
			managed = "in-band-status";
		};

		gpio0: gpio@ff708000 {
			status = "okay";
		};

		fifo: fifo@0xC0700000 {
			compatible = "or,fpga-fifo";
			status = "okay";
			reg = < 0xc0700000 0x10 >;
			interrupts = < 0 40 IRQ_TYPE_LEVEL_HIGH >;
			interrupt-parent = <&intc>;
			interrupt-names= "fifoirq";
			fifo-size = <1024>;
		};

		sfp_i2c_clk: sfp_i2c_clk {
			#clock-cells = <0>;
			compatible = "fixed-clock";
			clock-frequency = <50000000>;
			status = "okay";
		};

		sfp_i2c0: i2c@0xc0605000 {
			#address-cells = <1>;
			#size-cells = <1>;
			compatible = "altr,softip-i2c-v1.0";
			reg = <0xc0605000 0x100>;
			interrupt-parent = <&intc>;
			interrupts = <0 61 4>;
			clocks = <&sfp_i2c_clk>;
			clock-frequency = <100000>;
			fifo-size = <4>;
			status = "okay";
		};

		sfp_pio0: sfp_pio@0xc0601000 {
			compatible = "altr,pio-1.0";
			reg = <0xc0601000 0x0100>;
			altr,gpio-bank-width = <4>;
			resetvalue = <15>;
			#gpio-cells = <2>;
			gpio-controller;
			status = "okay";
		};

		sfp0: sfp0 {
			compatible = "sff,sfp";
			i2c-bus = <&sfp_i2c0>;
			mod-def0-gpio = <&sfp_pio0 0 GPIO_ACTIVE_LOW>;
			los-gpio = <&sfp_pio0 1 GPIO_ACTIVE_HIGH>;
			tx-fault-gpios = <&sfp_pio0 2 GPIO_ACTIVE_HIGH>;
			tx-disable-gpios = <&sfp_pio0 3 GPIO_ACTIVE_HIGH>;
			rate-select0-gpios = <&sfp_pio0 4 GPIO_ACTIVE_HIGH>;
			maximum-power-milliwatt = <2000>;
			status = "okay";
		};


		sfp_i2c1: i2c@0xc0606000 {
			#address-cells = <1>;
			#size-cells = <1>;
			compatible = "altr,softip-i2c-v1.0";
			reg = <0xc0606000 0x100>;
			interrupt-parent = <&intc>;
			interrupts = <0 62 4>;
			clocks = <&sfp_i2c_clk>;
			clock-frequency = <100000>;
			fifo-size = <4>;
			status = "okay";
		};

		sfp_pio1: sfp_pio@0xc0602000 {
			compatible = "altr,pio-1.0";
			reg = <0xc0602000 0x0100>;
			altr,gpio-bank-width = <4>;
			resetvalue = <15>;
			#gpio-cells = <2>;
			gpio-controller;
			status = "okay";
		};

		sfp1: sfp1 {
			compatible = "sff,sfp";
			i2c-bus = <&sfp_i2c1>;
			mod-def0-gpio = <&sfp_pio1 0 GPIO_ACTIVE_LOW>;
			los-gpio = <&sfp_pio1 1 GPIO_ACTIVE_HIGH>;
			tx-fault-gpios = <&sfp_pio1 2 GPIO_ACTIVE_HIGH>;
			tx-disable-gpios = <&sfp_pio1 3 GPIO_ACTIVE_HIGH>;
			rate-select0-gpios = <&sfp_pio1 4 GPIO_ACTIVE_HIGH>;
			maximum-power-milliwatt = <2000>;
			status = "okay";
		};

		sfp_i2c2: i2c@0xc0607000 {
			#address-cells = <1>;
			#size-cells = <1>;
			compatible = "altr,softip-i2c-v1.0";
			reg = <0xc0607000 0x100>;
			interrupt-parent = <&intc>;
			interrupts = <0 63 4>;
			clocks = <&sfp_i2c_clk>;
			clock-frequency = <100000>;
			fifo-size = <4>;
			status = "okay";
		};

		sfp_pio2: sfp_pio@0xc0603000 {
			compatible = "altr,pio-1.0";
			reg = <0xc0603000 0x0100>;
			altr,gpio-bank-width = <4>;
			resetvalue = <15>;
			#gpio-cells = <2>;
			gpio-controller;
			status = "okay";
		};

		sfp2: sfp2 {
			compatible = "sff,sfp";
			i2c-bus = <&sfp_i2c2>;
			mod-def0-gpio = <&sfp_pio2 0 GPIO_ACTIVE_LOW>;
			los-gpio = <&sfp_pio2 1 GPIO_ACTIVE_HIGH>;
			tx-fault-gpios = <&sfp_pio2 2 GPIO_ACTIVE_HIGH>;
			tx-disable-gpios = <&sfp_pio2 3 GPIO_ACTIVE_HIGH>;
			rate-select0-gpios = <&sfp_pio2 4 GPIO_ACTIVE_HIGH>;
			maximum-power-milliwatt = <2000>;
			status = "okay";
		};

		sfp_i2c3: i2c@0xc0608000 {
			#address-cells = <1>;
			#size-cells = <1>;
			compatible = "altr,softip-i2c-v1.0";
			reg = <0xc0608000 0x100>;
			interrupt-parent = <&intc>;
			interrupts = <0 65 4>;
			clocks = <&sfp_i2c_clk>;
			clock-frequency = <100000>;
			fifo-size = <4>;
			status = "okay";
		};

		sfp_pio3: sfp_pio@0xc0604000 {
			compatible = "altr,pio-1.0";
			reg = <0xc0604000 0x0100>;
			altr,gpio-bank-width = <4>;
			resetvalue = <15>;
			#gpio-cells = <2>;
			gpio-controller;
			status = "okay";
		};

		sfp3: sfp3 {
			compatible = "sff,sfp";
			i2c-bus = <&sfp_i2c3>;
			mod-def0-gpio = <&sfp_pio3 0 GPIO_ACTIVE_LOW>;
			los-gpio = <&sfp_pio3 1 GPIO_ACTIVE_HIGH>;
			tx-fault-gpios = <&sfp_pio3 2 GPIO_ACTIVE_HIGH>;
			tx-disable-gpios = <&sfp_pio3 3 GPIO_ACTIVE_HIGH>;
			rate-select0-gpios = <&sfp_pio3 4 GPIO_ACTIVE_HIGH>;
			maximum-power-milliwatt = <2000>;
			status = "okay";
		};
	};
};

&i2c0 {
	status = "okay";

	rtc@56 {
		compatible = "abracon,abeoz9";
		reg = <0x56>;
		trickle-resistor-ohms=<5000>;
	};

	tmu: tmu@4d {
		compatible = "maxim,max6581";
		reg = <0x4d>;
		extended-range-enable;
		resistance-cancellation;
	};
};

--qMm9M+Fa2AknHoGS--
