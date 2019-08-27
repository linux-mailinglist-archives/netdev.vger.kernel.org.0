Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0ACA9E659
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 13:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729374AbfH0LCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 07:02:32 -0400
Received: from smark.slackware.pl ([88.198.48.135]:50404 "EHLO
        smark.slackware.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbfH0LCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 07:02:32 -0400
Received: from bek.lan.toxcorp.com (unknown [213.156.230.59])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: shasta@toxcorp.com)
        by smark.slackware.pl (Postfix) with ESMTPSA id 6C8CF2062C;
        Tue, 27 Aug 2019 13:02:29 +0200 (CEST)
To:     e1000-devel@lists.sourceforge.net
Cc:     shasta@toxcorp.com, mhemsley@open-systems.com,
        netdev@vger.kernel.org
From:   Jakub Jankowski <shasta@toxcorp.com>
Subject: SFP+ EEPROM readouts fail on X722 (ethtool -m: Invalid argument)
Message-ID: <ec481f17-cbf4-589d-807f-736421391c71@toxcorp.com>
Date:   Tue, 27 Aug 2019 13:03:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

We can't get SFP+ EEPROM readouts for X722 to work at all:

# ethtool -m eth10
Cannot get module EEPROM information: Invalid argument
# dmesg | tail -n 1
[  445.971974] i40e 0000:3d:00.3 eth10: Module EEPROM memory read not supported. Please update the NVM image.
# lspci | grep 3d:00.3
3d:00.3 Ethernet controller: Intel Corporation Ethernet Connection X722 for 10GbE SFP+ (rev 09)


We're running 4.19.65 kernel at the moment, testing using the newest out-of-tree Intel module

# modinfo -F version i40e
2.9.21

We also tried:
- 4.19.65 with in-tree i40e (2.3.2-k)
- stock Arch Linux (kernel 5.2.5, driver 2.8.20-k)
and the results are the same, as shown above.

# ethtool -i eth10
driver: i40e
version: 2.9.21
firmware-version: 3.31 0x80000d31 1.1767.0
expansion-rom-version:
bus-info: 0000:3d:00.3
supports-statistics: yes
supports-test: yes
supports-eeprom-access: yes
supports-register-dump: yes
supports-priv-flags: yes
# dmidecode -s baseboard-manufacturer
Intel Corporation
# dmidecode -s baseboard-product-name
S2600WFT
# dmidecode -s baseboard-version
H48104-853

# lspci -vvv
(...)
3d:00.3 Ethernet controller: Intel Corporation Ethernet Connection X722 for 10GbE SFP+ (rev 09)
	DeviceName: Intel PCH Integrated 10 Gigabit Ethernet Controller
	Subsystem: Intel Corporation Ethernet Connection X722 for 10GbE SFP+
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 112
	NUMA node: 0
	Region 0: Memory at ab000000 (64-bit, prefetchable) [size=16M]
	Region 3: Memory at b0000000 (64-bit, prefetchable) [size=32K]
	Expansion ROM at <ignored> [disabled]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable+ 64bit+
		Address: 0000000000000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [70] MSI-X: Enable+ Count=129 Masked-
		Vector table: BAR=3 offset=00000000
		PBA: BAR=3 offset=00001000
	Capabilities: [a0] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset+ SlotPowerLimit 0.000W
		DevCtl:	CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop- FLReset-
			MaxPayload 256 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ NonFatalErr- FatalErr- UnsupReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s (ok), Width x1 (ok)
			TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Range AB, TimeoutDis+, LTR-, OBFF Not Supported
			 AtomicOpsCap: 32bit- 64bit- 128bitCAS-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
			 AtomicOpsCtl: ReqEn-
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [e0] Vital Product Data
		Product Name: Example VPD
		Read-only fields:
			[V0] Vendor specific:
			[RV] Reserved: checksum good, 0 byte(s) reserved
		End
	Capabilities: [100 v2] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+
		AERCap:	First Error Pointer: 00, ECRCGenCap+ ECRCGenEn- ECRCChkCap+ ECRCChkEn-
			MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
		HeaderLog: 00000000 00000000 00000000 00000000
	Capabilities: [150 v1] Alternative Routing-ID Interpretation (ARI)
		ARICap:	MFVC- ACS-, Next Function: 0
		ARICtl:	MFVC- ACS-, Function Group: 0
	Capabilities: [160 v1] Single Root I/O Virtualization (SR-IOV)
		IOVCap:	Migration-, Interrupt Message Number: 000
		IOVCtl:	Enable- Migration- Interrupt- MSE- ARIHierarchy-
		IOVSta:	Migration-
		Initial VFs: 32, Total VFs: 32, Number of VFs: 0, Function Dependency Link: 03
		VF offset: 109, stride: 1, Device ID: 37cd
		Supported Page Size: 00000553, System Page Size: 00000001
		Region 0: Memory at 00000000af000000 (64-bit, prefetchable)
		Region 3: Memory at 00000000b0020000 (64-bit, prefetchable)
		VF Migration: offset: 00000000, BIR: 0
	Capabilities: [1a0 v1] Transaction Processing Hints
		Device specific mode supported
		No steering table available
	Capabilities: [1b0 v1] Access Control Services
		ACSCap:	SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd- EgressCtrl- DirectTrans-
		ACSCtl:	SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd- EgressCtrl- DirectTrans-
	Kernel driver in use: i40e
	Kernel modules: i40e


Same kernel+i40e, same SFP+ module - but on Intel X710, works like a treat:

# lspci | grep X7
81:00.0 Ethernet controller: Intel Corporation Ethernet Controller X710 for 10GbE SFP+ (rev 01)
81:00.1 Ethernet controller: Intel Corporation Ethernet Controller X710 for 10GbE SFP+ (rev 01)
# ethtool -m eth8
	Identifier                                : 0x03 (SFP)
	Extended identifier                       : 0x04 (GBIC/SFP defined by 2-wire interface ID)
	Connector                                 : 0x07 (LC)
	Transceiver codes                         : 0x10 0x00 0x00 0x01 0x00 0x00 0x00 0x00 0x00
	Transceiver type                          : 10G Ethernet: 10G Base-SR
	Transceiver type                          : Ethernet: 1000BASE-SX
	Encoding                                  : 0x06 (64B/66B)
	BR, Nominal                               : 10300MBd
         (...)
# ethtool -i eth8
driver: i40e
version: 2.9.21
firmware-version: 6.01 0x800035cf 1.1876.0
expansion-rom-version:
bus-info: 0000:81:00.0
supports-statistics: yes
supports-test: yes
supports-eeprom-access: yes
supports-register-dump: yes
supports-priv-flags: yes
#


Is this a known problem?


Best regards,
  Jakub

