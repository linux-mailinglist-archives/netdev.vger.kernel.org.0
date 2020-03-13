Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD9F185098
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 22:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgCMVFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 17:05:01 -0400
Received: from hs2.cadns.ca ([149.56.24.197]:58507 "EHLO hs2.cadns.ca"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726637AbgCMVFB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 17:05:01 -0400
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
        by hs2.cadns.ca (Postfix) with ESMTPSA id 6B1472580E7
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 17:04:57 -0400 (EDT)
Authentication-Results: hs2.cadns.ca;
        spf=pass (sender IP is 209.85.210.44) smtp.mailfrom=sriram.chadalavada@mindleap.ca smtp.helo=mail-ot1-f44.google.com
Received-SPF: pass (hs2.cadns.ca: connection is authenticated)
Received: by mail-ot1-f44.google.com with SMTP id 111so11563761oth.13
 for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 14:04:57 -0700 (PDT)
X-Gm-Message-State: ANhLgQ1zjNEWKw2vI29uSm/kzgK0N9XvVB7FkSFoaChhGsvQub6CHTrN
 B+EBc2S0IVMFfrsmBBAvbGje05EYFHEi786F+l8=
X-Google-Smtp-Source: ADFU+vtpuSfTSOPssW85SoS8ZVxVwBlFRIdCL+fDN4UKgHW5R4XIlDsAYjQqAgz6/3XCl6GNOFC1S3WNTsGbU8HFHXE=
X-Received: by 2002:a9d:7cd1:: with SMTP id r17mr6031295otn.183.1584133496691;
 Fri, 13 Mar 2020 14:04:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAOK2joFxzSETFgHX7dRuhWPVSSEYswJ+-xfSxbPr5n3LcsMHzw@mail.gmail.com>
 <20200305225115.GC25183@lunn.ch>
 <CAOK2joHQRaBaW0_xexZLTp432ByvC6uhgJvjsY8t3HNyL9GUwg@mail.gmail.com>
 <20200313094722.GC14553@lunn.ch>
In-Reply-To: <20200313094722.GC14553@lunn.ch>
From:   Sriram Chadalavada <sriram.chadalavada@mindleap.ca>
Date:   Fri, 13 Mar 2020 17:04:45 -0400
X-Gmail-Original-Message-ID: <CAOK2joEztceZ+XyWn0_mywODW9Q-=zzbuBSbZj=fwUwTvmzvOQ@mail.gmail.com>
Message-ID: <CAOK2joEztceZ+XyWn0_mywODW9Q-=zzbuBSbZj=fwUwTvmzvOQ@mail.gmail.com>
Subject: Re: Information on DSA driver initialization
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
Content-Type: multipart/mixed; boundary="0000000000005943e605a0c2d2d6"
X-PPP-Message-ID: <20200313210457.9173.34866@hs2.cadns.ca>
X-PPP-Vhost: mindleap.ca
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000005943e605a0c2d2d6
Content-Type: text/plain; charset="UTF-8"

Hi Andrew,
  Thank you for the clarification. I'm trying with new binding but am
facing difficulty with appropriate device tree creation.

  Please find attached a block diagram of the DSA Marvell 6176 switch
I am working with.

  This entry in the device tree is what worked with CONFIG_NET_DSA_LEGACY.
dsa@0 {
                compatible = "marvell,dsa";
                #address-cells = <2>;
                #size-cells = <0>;
                interrupt-parent = <&gpio2>;
                interrupts = <&gpio2 31 IRQ_TYPE_LEVEL_LOW>;
                dsa,ethernet = <&eth0>;

                switch@0 {
                        #address-cells = <1>;
                        #size-cells = <0>;
                        reg = <0 0>;

                        port@0 {
                                reg = <0>;
                                label = "eth1";
                        };

                        port@1 {
                                reg = <1>;
                                label = "eth2";
                        };

                        port@2 {
                                reg = <2>;
                                label = "eth3";
                        };

                        port@3 {
                                reg = <3>;
                                label = "eth4";
                        };

                        port@4 {
                                reg = <4>;
                                label = "eth5";
                        };

                        port@5 {
                                reg = <5>;
                                label = "cpu";
                        };
                };
        };

and this attempt with the new binding (using imx6qdl-zii-rdu2.dtsi as
an example) :

 /* Marvell 6176 switch under new DSA binding */
fec {
                pinctrl-names = "default";
                pinctrl-0 = <&pinctrl_enet>;
                phy-mode = "rgmii-id";
                phy-reset-gpios = <&gpio1 30 GPIO_ACTIVE_LOW>;
                status = "okay";

                mdio {
                  #address-cells = <1>;
                  #size-cells = <0>;
                  interrupt-parent = <&gpio2>;
                  interrupts = <&gpio2 31 IRQ_TYPE_LEVEL_LOW>;


                  switch: switch@0 {
                        compatible = "marvell,mv88e6085";
                        reg = <0>;
                        dsa,member = <0 0>;

                        ports{
                                #address-cells = <1>;
                                #size-cells = <0>;
                                port@0 {
                                        reg = <0>;
                                        label = "port0";
                                };

                                port@1 {
                                        reg = <1>;
                                        label = "port1";
                                };

                                port@2 {
                                        reg = <2>;
                                        label = "port2";
                                };

                                port@5 {
                                        reg = <5>;
                                        label = "cpu";
                                        ethernet = <&fec>; /*Similar
to how CPU port is defined in imx6dl-zii-rd2.dtsi */
                                };
                            };
                       };
                       mdio {
                        #address-cells = <1>;
                        #size-cells = <0>;
                        status = "okay";
                      };
                };
     };

causes kernel PANIC after SEVERAL warnings during the build process:

/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/linux-4.19.106/scripts/dtc/dtc
-O dtb -i/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/linux-4.19.106/arch/arm/boot/dts/
-Wno-unit_address_vs_reg -Wno-simple_bus_reg -Wno-unit_address_format
-Wno-pci_bridge -Wno-pci_device_bus_num -Wno-pci_device_reg
-Wno-avoid_unnecessary_addr_size -Wno-alias_paths
-Wno-graph_child_address -Wno-graph_port -Wno-unique_unit_address  -o
/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/image-imx6q-sd-hub.dtb
/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/image-imx6q-sd-hub.dtb.tmp
/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/image-imx6q-sd-hub.dtb:
Warning (reg_format): /ecspi2/hi3593@0:reg: property has invalid
length (4 bytes) (#address-cells == 2, #size-cells == 1)
/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/image-imx6q-sd-hub.dtb:
Warning (reg_format): /i2c1/pca9538@70:reg: property has invalid
length (4 bytes) (#address-cells == 2, #size-cells == 1)
/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/image-imx6q-sd-hub.dtb:
Warning (reg_format): /i2c1/gpio@71:reg: property has invalid length
(4 bytes) (#address-cells == 2, #size-cells == 1)
/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/image-imx6q-sd-hub.dtb:
Warning (reg_format): /i2c1/gpio@72:reg: property has invalid length
(4 bytes) (#address-cells == 2, #size-cells == 1)
/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/image-imx6q-sd-hub.dtb:
Warning (reg_format): /i2c1/pca9538@73:reg: property has invalid
length (4 bytes) (#address-cells == 2, #size-cells == 1)
/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/image-imx6q-sd-hub.dtb:
Warning (reg_format): /i2c1/lm75@48:reg: property has invalid length
(4 bytes) (#address-cells == 2, #size-cells == 1)
/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/image-imx6q-sd-hub.dtb:
Warning (reg_format): /i2c1/eeprom@54:reg: property has invalid length
(4 bytes) (#address-cells == 2, #size-cells == 1)
/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/image-imx6q-sd-hub.dtb:
Warning (reg_format): /i2c1/rtc@51:reg: property has invalid length (4
bytes) (#address-cells == 2, #size-cells == 1)
/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/image-imx6q-sd-hub.dtb:
Warning (avoid_default_addr_size): /ecspi2/hi3593@0: Relying on
default #address-cells value
/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/image-imx6q-sd-hub.dtb:
Warning (avoid_default_addr_size): /ecspi2/hi3593@0: Relying on
default #size-cells value
/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/image-imx6q-sd-hub.dtb:
Warning (avoid_default_addr_size): /i2c1/pca9538@70: Relying on
default #address-cells value
/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/image-imx6q-sd-hub.dtb:
Warning (avoid_default_addr_size): /i2c1/pca9538@70: Relying on
default #size-cells value
/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/image-imx6q-sd-hub.dtb:
Warning (avoid_default_addr_size): /i2c1/gpio@71: Relying on default
#address-cells value
/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/image-imx6q-sd-hub.dtb:
Warning (avoid_default_addr_size): /i2c1/gpio@71: Relying on default
#size-cells value
/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/image-imx6q-sd-hub.dtb:
Warning (avoid_default_addr_size): /i2c1/gpio@72: Relying on default
#address-cells value
/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/image-imx6q-sd-hub.dtb:
Warning (avoid_default_addr_size): /i2c1/gpio@72: Relying on default
#size-cells value
/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/image-imx6q-sd-hub.dtb:
Warning (avoid_default_addr_size): /i2c1/pca9538@73: Relying on
default #address-cells value
/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/image-imx6q-sd-hub.dtb:
Warning (avoid_default_addr_size): /i2c1/pca9538@73: Relying on
default #size-cells value
/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/image-imx6q-sd-hub.dtb:
Warning (avoid_default_addr_size): /i2c1/lm75@48: Relying on default
#address-cells value
/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/image-imx6q-sd-hub.dtb:
Warning (avoid_default_addr_size): /i2c1/lm75@48: Relying on default
#size-cells value
/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/image-imx6q-sd-hub.dtb:
Warning (avoid_default_addr_size): /i2c1/eeprom@54: Relying on default
#address-cells value
/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/image-imx6q-sd-hub.dtb:
Warning (avoid_default_addr_size): /i2c1/eeprom@54: Relying on default
#size-cells value
/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/image-imx6q-sd-hub.dtb:
Warning (avoid_default_addr_size): /i2c1/rtc@51: Relying on default
#address-cells value
/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/image-imx6q-sd-hub.dtb:
Warning (avoid_default_addr_size): /i2c1/rtc@51: Relying on default
#size-cells value
/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/image-imx6q-sd-hub.dtb:
Warning (interrupts_property): /fec/mdio:#interrupt-cells: size is
(12), expected multiple of 8
/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/image-imx6q-sd-smu.dtb:
Warning (interrupts_property): /dsa@0:#interrupt-cells: size is (12),
expected multiple of 8
rm -f /home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/image-imx6q-sd-hub.dtb.tmp
cp -fpR /home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/linux-4.19.106/arch/arm/boot/dts/imx6q-sd-hub.dtb
/home/schadalavada/data/buildcore2/buildcore/bin/targets/imx6/generic-glibc/imx6q-sd-hub.dtb;
/home/schadalavada/data/buildcore2/buildcore/scripts/mkits.sh -D
imx6q-sd-hub -o
/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/fit-imx6q-sd-hub.its
-k /home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/zImage
-d /home/schadalavada/data/buildcore2/buildcore/bin/targets/imx6/generic-glibc/imx6q-sd-hub.dtb
-C none -a 0x10008000 -e 0x10008000 -c "config@1" -A arm -v 4.19.106
/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/fit-imx6q-sd-hub-initramfs.itb.tmp:
Warning (unit_address_vs_reg): /images/kernel@1: node has a unit name,
but no reg property
/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/fit-imx6q-sd-hub-initramfs.itb.tmp:
Warning (unit_address_vs_reg): /images/kernel@1/hash@1: node has a
unit name, but no reg property
/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/fit-imx6q-sd-hub-initramfs.itb.tmp:
Warning (unit_address_vs_reg): /images/kernel@1/hash@2: node has a
unit name, but no reg property
/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/fit-imx6q-sd-hub-initramfs.itb.tmp:
Warning (unit_address_vs_reg): /images/fdt@1: node has a unit name,
but no reg property
/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/fit-imx6q-sd-hub-initramfs.itb.tmp:
Warning (unit_address_vs_reg): /images/fdt@1/hash@1: node has a unit
name, but no reg property
/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/fit-imx6q-sd-hub-initramfs.itb.tmp:
Warning (unit_address_vs_reg): /images/fdt@1/hash@2: node has a unit
name, but no reg property
/home/schadalavada/data/buildcore2/buildcore/build_dir/target-arm_cortex-a9+neon_glibc_eabi/linux-imx6/fit-imx6q-sd-hub-initramfs.itb.tmp:
Warning (unit_address_vs_reg): /configurations/config@1: node has a
unit name, but no reg property


Where should I be investigating next?

Thank you,
Sriram

On Fri, Mar 13, 2020 at 5:47 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Thu, Mar 12, 2020 at 06:38:24PM -0400, Sriram Chadalavada wrote:
> > Hi Andrew,
> >    Thank you for your response.
> >
> >   Yes. There are patches applied.  I did scatter printks/pr_info but
> > don't see anything yet from the Marvell 6176 switch without
> > CONFIG_NET_DSA_LEGACY enabled.
>
> CONFIG_NET_DSA_LEGACY is dead. Don't use it. Use the new binding.
>
> >
> >     One question I have is if CONFIG_NET_DSA_LEGACY is NOT selected,
> > what in the 4.19 kernel takes over the function of dsa_probe function
> > in net/dsa/legacy.c and mv88e6xxx_drv_probe in
> > drivers/net/dsa/mv88e6xxx/chip.c ?
>
> When the mdio bus is registered, the mdio driver calls
> of_mdiobus_register() passing a DT node for the bus. The bus is walked
> and devices instantiated.
>
>     Andrew

--0000000000005943e605a0c2d2d6
Content-Type: application/pdf; name="Untitled Diagram.pdf"
Content-Disposition: attachment; filename="Untitled Diagram.pdf"
Content-Transfer-Encoding: base64
Content-ID: <f_k7qliybs0>
X-Attachment-Id: f_k7qliybs0

JVBERi0xLjQKJdPr6eEKMSAwIG9iago8PC9DcmVhdG9yIChDaHJvbWl1bSkKL1Byb2R1Y2VyIChT
a2lhL1BERiBtNzUpCi9TdWJqZWN0ICglM0NteGZpbGUlMjBob3N0JTNEJTIyYXBwLmRpYWdyYW1z
Lm5ldCUyMiUyMG1vZGlmaWVkJTNEJTIyMjAyMC0wMy0xM1QxOSUzQTUwJTNBMDEuMTkwWiUyMiUy
MGFnZW50JTNEJTIyTW96aWxsYSUyRjUuMCUyMFwoTWFjaW50b3NoJTNCJTIwSW50ZWwlMjBNYWMl
MjBPUyUyMFglMjAxMF8xNV8zXCklMjBBcHBsZVdlYktpdCUyRjUzNy4zNiUyMFwoS0hUTUwlMkMl
MjBsaWtlJTIwR2Vja29cKSUyMENocm9tZSUyRjgwLjAuMzk4Ny4xMzIlMjBTYWZhcmklMkY1Mzcu
MzYlMjIlMjBldGFnJTNEJTIyOGF1dC10YVBVaUNPV19TUGJFbGMlMjIlMjB2ZXJzaW9uJTNEJTIy
MTIuOC40JTIyJTIwdHlwZSUzRCUyMmdvb2dsZSUyMiUzRSUzQ2RpYWdyYW0lMjBpZCUzRCUyMjFP
ZjFwSHRxb1JHdDVjR05JRElxJTIyJTIwbmFtZSUzRCUyMlBhZ2UtMSUyMiUzRTVaZkJjdG93RUlh
ZnhzZDJzR1ViY2t3TUlaa2toQ25UWWRwTFJyVVhXNDFzTWJMQWtLZXZGTXNZV3liUURyU0hub0ol
MkZyVmJ5dCUyRjh1eEVKQnVobHp2RXllV0FUVWNuclJ4a0pEeTNGczUyb2clMkZ5aGxXeXA5dDFj
S01TZVJEcXFGR1hrRExWWmhLeEpCM2dnVWpGRkJsazB4WkZrR29XaG9tSE5XTk1NV2pEWlBYZUlZ
REdFV1ltcXFjeEtKcEZRSFhxJTJGVzc0REVTWFd5M2RNckthNkN0WkFuT0dMRm5vUkdGZ280WTZM
OGxHNENvQXBleGFYY2QzdGdkWGN4RHBrNFpjUFB4OG1VRDhiSWY5aE8zbnolMkY0ZnZMajlFbm5X
V042VXElMkY4QlBtNjNLamIlMkZkOWRlJTJCQ2lERFI3eUMyRlJqT1Zsa0VLcmR0b1pzaUlRSm1T
eHlxMVVKYVFXcUpTS2xlTnU5YUhReGN3R1pQMG5jZkEwdEI4SzBNMGF1bzRxaU5oQ3FIRkhWWm5M
N1drcjJTJTJCRnJEMmdueExuVU5TMzdRdkxyWnJXZGZpcnglMkZHODlmaDJ0NGlUR2F1M0VIdTJE
NlZiMG00JTJCSURYTDFUY1Jsc09nZ2V4dVVleCUyQlYxMEVLWG91VVl0QXhHa0VYWHFtWGxVMGh4
bnBOUXNzZ0Y1c0tVRFZvUUdZMThsTlVSRnBYR2dXSkIxczMwWFlEMENWTkc1TUc3VXJpdFVqaHVp
M0hPVmp3RXZXdSUyRmcxdUp2RU10VUNXU3FHSVFSaUpKRDIlMkYzd3BZcUlEOTg0Zlk1MVlYcjhw
Y1phelBzbVA2NVA1QTVpWWIzeiUyQjhqbTVmemZVSGlGWmVGWUpsOGZwNDhmak1NSk50Rk5MMlJD
ODVlSVdCVUprSERqR1V5OG1aQktHMUptSkk0VXdhVGxnR3AzNmptSSUyRkpyNEZvdnBDU0sxREdk
cmR0czdqTjByNGRhRlhETTdyMzZ3TEZuNzE3UHFNNjlCS1cyalVRQ1BBTmxuNEJsRWplbEV1QSUy
RkgzOHRDOXNERTZEdGRCQWNlQmNpMlA5djV4JTJGeTNjOWUwODUlMkJpJTJGS3BFOUJNaFhxdFZH
ZWFnUjJYN251WG40SzIlMkJUVTV2VE1IM1Y5dko2ODFqenl6bmR3T0J6bSUyRlA0JTJGa1klMkYy
YnVNUmElMkYyZUJScjhBJTNDJTJGZGlhZ3JhbSUzRSUzQyUyRm14ZmlsZSUzRSkKL0NyZWF0aW9u
RGF0ZSAoRDoyMDIwMDMxMzE5NTAwMyswMCcwMCcpCi9Nb2REYXRlIChEOjIwMjAwMzEzMTk1MDAz
KzAwJzAwJyk+PgplbmRvYmoKMyAwIG9iago8PC9jYSAxCi9CTSAvTm9ybWFsPj4KZW5kb2JqCjQg
MCBvYmoKPDwvQ0EgMQovY2EgMQovTEMgMAovTEogMAovTFcgMQovTUwgNAovU0EgdHJ1ZQovQk0g
L05vcm1hbD4+CmVuZG9iago2IDAgb2JqCjw8L0NBIDEKL2NhIDEKL0xDIDAKL0xKIDAKL0xXIDEK
L01MIDEwCi9TQSB0cnVlCi9CTSAvTm9ybWFsPj4KZW5kb2JqCjcgMCBvYmoKPDwvRmlsdGVyIC9G
bGF0ZURlY29kZQovTGVuZ3RoIDEzMzY+PiBzdHJlYW0KeJztWF9rJDcMf99PMc+FOrZsyzKUQhOa
PF8T6AdIe1dKUuj1+0N/kj1ebe6alN4W7mF3GcaWLVl/f5qZQLnbb4v4fxvctHXaHp8Pfx50hWqN
W6beQ0rSto+/Hn7+ZvsDixR659JKMwGnM3CnTf8/3W1j8PHD4eoubx/+MqFSQUsxqbj3nhIH5R3+
p8dzSET5XxyfQulCueWT4WsKQfqWU9yeD1WSjZ50FGqPvdi8CoXUmGw1xNq4Gq3VKkZKjbD1EWw5
5FxzNiqJgEVp0iUNWqkC71YpoZQS7eDAUiMbd4EZMVaj9gSLsbOGGoUbaCkkkaJHs81q4ibGx7A0
5W5U7IBcpfVSu+pHgZKkBloLmbN0o3FmnKTcLTQsq6kZxmVIryIh1dK60XC+nSqhSI6DhkwRMm4J
kpIyF1UiCTb2EEWYQKshxi7ZaNjR2GgVfhvMPdQSTSEEOEJL29lSMoM5MMNhRhNqUV3YApUCYwZ3
L5TJqBpoKN6RLQmKxo7dY9Z1r444aWTHyKLbNieDR4yLP41njMdhUy0eMe6bU59HjNkbynuMB/d0
CY8Yy3b0HFuIG3sXM8NzMe0unsFgC3Tpmwsaa6DZBK7wso16nckxE4GNRzaXL2yiRUZOsR2fhr0r
73jo2TeXn2z2tOQzmc1ykVkHM+dZfZRi3VxtsPnSDN6LiHefK/OqNt6j4+pRafhp7LCjAWxGBTet
20x77I/7Mu3ZcZSntJFH/uRMI+OqU1FpyMwmzpRMew5Po3sy7j3bd/fozr0qjm7MtJePd7hSR6Ed
g6K0UZArdplG5dJJkJWqNe7TIdPAAnZpozRFjXqSYEpVZCGXipkMgVJ3Gas0xap8kttKRZGaknsV
KA3oZ2bv1aI0xcnky0qJiqe+/lCxe+RWnWKf1a9xWE0j1sd9q+KdvIUJ7mCHHk7FhTPOlIVHzmiH
XM49C+OcGxcW7g6nBZp1OnyGZsLrCOwM4YJhF2wH2C4rFrS77FktwOWZaxYuI1dDcZm7Go/Lcdei
XDWsZuaqZjU9V1+uPbpKXH3UVWyyTm/3x8Nv88EgasseA2vZ5dKyLy370rIvLfvSsi8t+9Kyv66W
fW/v7W98GZiv3dcPh6vbuiGdH97j5dy+QqStREJ1Eg6BkQ/Ph+9izEh6JG6sFReyugiu23HpYgIt
YT39MMZKq4wL83KDe8Md83L9/fbw++HHh1eV/A/fD0ocjxy4xeMXjc8/uLzc++UeyxUeIwNuytNl
BHMz3JBlN/mfeEvgyupuGDl4q7qPprvbF7ns6o5V71I4gEDFHthgvY7Q1q2ImbvNcSTuijz4jVnV
pNJRjhmlBJb73RXI0wBbhshSxCaZQ8Umd9zTWoPksbb4nuwRc6l4FnlLv6E12oeYySoox6TTp1OL
qqLAyzUZE6ffmeR9ebYhKwI3YJC6xxUo2nEkFBtQ1gil71n0egbiYSxwidBdwz3kabEab4rxRosf
hVxlZKQBQZuFbXvekF870K9n6Mtl1xd8KMJIt8YLjzXpqgIU+GXTDTf/E1IgGklwkX7wfAsqPtl8
BqwoZaArAfAnVNwMR5tT5YiqJJN2PegGB2mO21uwgjYmRZ2eq4OkPagq1+TREcnHGeeAG33SgYUt
adU+r2lGT9Pv20+LAl/0nMu2z8XAZ81H3x/jLi8AaNJZv0vbITKOICffFNBp+mRt8J2U+NkkvtBR
ocFgw7g6Dyx4YZeddro2+T6j4xkk3r9SJHVAPyCV3mynL/eeo5222RKJ1xOI1sP1KS68O/wNGq75
WAplbmRzdHJlYW0KZW5kb2JqCjIgMCBvYmoKPDwvVHlwZSAvUGFnZQovUmVzb3VyY2VzIDw8L1By
b2NTZXRzIFsvUERGIC9UZXh0IC9JbWFnZUIgL0ltYWdlQyAvSW1hZ2VJXQovRXh0R1N0YXRlIDw8
L0czIDMgMCBSCi9HNCA0IDAgUgovRzYgNiAwIFI+PgovRm9udCA8PC9GNSA1IDAgUj4+Pj4KL01l
ZGlhQm94IFswIDAgNjEyIDc5Ml0KL0NvbnRlbnRzIDcgMCBSCi9TdHJ1Y3RQYXJlbnRzIDAKL1Bh
cmVudCA4IDAgUj4+CmVuZG9iago4IDAgb2JqCjw8L1R5cGUgL1BhZ2VzCi9Db3VudCAxCi9LaWRz
IFsyIDAgUl0+PgplbmRvYmoKOSAwIG9iago8PC9UeXBlIC9DYXRhbG9nCi9QYWdlcyA4IDAgUj4+
CmVuZG9iagoxMCAwIG9iago8PC9MZW5ndGgxIDM5MTQ4Ci9GaWx0ZXIgL0ZsYXRlRGVjb2RlCi9M
ZW5ndGggMTY2NTA+PiBzdHJlYW0KeJztvQd8VFXXN7r2PvuUKUkmkzpJJjOTZFIhDQKEBBhCQm/S
QzMBAgSpIURRUVQ0EBE7IGDBQlcCRA0giAgCVkQFKSpdLDyWBxskM3ftPZMQENT393m/e797meF/
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
ydeuWVVmLykvb+ijBHvBsmUzJlWV3VJiH7vkOuPDicyYXCxGWNw4vjHF15VFCe/lciclopOSSdt5
J+WlE8e/iUK5Tt2epeOKy2eUlUzHfT9pCp+F77z3jEmjsN3+U4tHo4T7lk2ZOqWM7/PiiXbvrem9
pkyeMh1v4+r6rvSeYu+EYhlXgk7g/wJmcWHpCmVuZHN0cmVhbQplbmRvYmoKMTEgMCBvYmoKPDwv
VHlwZSAvRm9udERlc2NyaXB0b3IKL0ZvbnROYW1lIC9IZWx2ZXRpY2EKL0ZsYWdzIDEyCi9Bc2Nl
bnQgNzcwLjAxOTUzCi9EZXNjZW50IDIyOS45ODA0NwovU3RlbVYgODkuMzU1NDY5Ci9DYXBIZWln
aHQgNzE3LjI4NTE2Ci9JdGFsaWNBbmdsZSAwCi9Gb250QkJveCBbLTk1MC42ODM1OSAtNDgwLjk1
NzAzIDE0NDUuODAwNzggMTEyMS41ODIwM10KL0ZvbnRGaWxlMiAxMCAwIFI+PgplbmRvYmoKMTIg
MCBvYmoKPDwvVHlwZSAvRm9udAovRm9udERlc2NyaXB0b3IgMTEgMCBSCi9CYXNlRm9udCAvSGVs
dmV0aWNhCi9TdWJ0eXBlIC9DSURGb250VHlwZTIKL0NJRFRvR0lETWFwIC9JZGVudGl0eQovQ0lE
U3lzdGVtSW5mbyA8PC9SZWdpc3RyeSAoQWRvYmUpCi9PcmRlcmluZyAoSWRlbnRpdHkpCi9TdXBw
bGVtZW50IDA+PgovVyBbMCBbNjMzLjc4OTA2IDAgMCAyNzcuODMyMDNdIDIwIDI2IDU1Ni4xNTIz
NCAzOCAzOSA3MjIuMTY3OTcgNDAgWzY2Ni45OTIxOSAwIDAgNzIyLjE2Nzk3IDI3Ny44MzIwMyAw
IDAgNTU2LjE1MjM0IDgzMy4wMDc4MSA3MjIuMTY3OTcgNzc3LjgzMjAzIDY2Ni45OTIxOV0gNTYg
WzcyMi4xNjc5NyAwIDAgMCA2NjYuOTkyMTldIDY4IFs1NTYuMTUyMzQgMCA1MDAgMCA1NTYuMTUy
MzQgMjc3LjgzMjAzIDU1Ni4xNTIzNCA1NTYuMTUyMzRdIDc2IDgwIDIyMi4xNjc5NyA4MSA4MyA1
NTYuMTUyMzQgODUgWzMzMy4wMDc4MSA1MDAgMjc3LjgzMjAzIDU1Ni4xNTIzNCA1MDAgNzIyLjE2
Nzk3XSAxOTIgWzUwMF1dCi9EVyAwPj4KZW5kb2JqCjEzIDAgb2JqCjw8L0ZpbHRlciAvRmxhdGVE
ZWNvZGUKL0xlbmd0aCAzMjg+PiBzdHJlYW0KeJxdkstugzAQRff+Ci/bRQTmFSIhpIQ2Eos+VNoP
IPaQWirGMs6Cv6+ZSVKplox0xnNnrhlHTfvUGu159O4m2YHngzbKwTxdnAR+grM2TCRcaemvhF85
9pZFQdwts4exNcPEqorz6COczt4t/GGvphM8sujNKXDanPnDV9MF7i7W/sAIxvOY1TVXMIRKL719
7UfgEco2rQrn2i+boPnL+Fws8ARZkBs5KZhtL8H15gysisOqeXUMq2Zg1L/zklSnQX73DrPTkB3H
SVyvJDKkVCClJVKeEzVEO6SMMgvKzAqilOhI1CA16OcQC/Rz7by9+bjbFjsUiT05KFCbUN2EjGRU
PjlQkPxkJQWpZ0rXyah1Vt4I/dA9ckH3oMzimYI5Ban7Nrl6JXfrb1zHfZ+RvDgXxoNvAueyTkQb
uD8bO9lVte5fa6+opgplbmRzdHJlYW0KZW5kb2JqCjUgMCBvYmoKPDwvVHlwZSAvRm9udAovU3Vi
dHlwZSAvVHlwZTAKL0Jhc2VGb250IC9IZWx2ZXRpY2EKL0VuY29kaW5nIC9JZGVudGl0eS1ICi9E
ZXNjZW5kYW50Rm9udHMgWzEyIDAgUl0KL1RvVW5pY29kZSAxMyAwIFI+PgplbmRvYmoKeHJlZgow
IDE0CjAwMDAwMDAwMDAgNjU1MzUgZiAKMDAwMDAwMDAxNSAwMDAwMCBuIAowMDAwMDAzMTU0IDAw
MDAwIG4gCjAwMDAwMDE1NTcgMDAwMDAgbiAKMDAwMDAwMTU5NCAwMDAwMCBuIAowMDAwMDIxNDA2
IDAwMDAwIG4gCjAwMDAwMDE2NzAgMDAwMDAgbiAKMDAwMDAwMTc0NyAwMDAwMCBuIAowMDAwMDAz
MzgzIDAwMDAwIG4gCjAwMDAwMDM0MzggMDAwMDAgbiAKMDAwMDAwMzQ4NSAwMDAwMCBuIAowMDAw
MDIwMjIzIDAwMDAwIG4gCjAwMDAwMjA0NjAgMDAwMDAgbiAKMDAwMDAyMTAwNyAwMDAwMCBuIAp0
cmFpbGVyCjw8L1NpemUgMTQKL1Jvb3QgOSAwIFIKL0luZm8gMSAwIFI+PgpzdGFydHhyZWYKMjE1
NDAKJSVFT0Y=
--0000000000005943e605a0c2d2d6--
