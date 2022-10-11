Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0214E5FAB06
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 05:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiJKDNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 23:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiJKDNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 23:13:45 -0400
Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.154.221.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A6E183B1;
        Mon, 10 Oct 2022 20:13:40 -0700 (PDT)
X-QQ-mid: bizesmtpipv601t1665457967tale
Received: from SJRobe ( [255.45.9.11])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 11 Oct 2022 11:12:45 +0800 (CST)
X-QQ-SSF: 01100000000000G0Z000000A0000000
X-QQ-FEAT: 6/K5pWSRdGoek6ADYkv2uta8uZYZ4h2JtQv+HoWg5pBCBN1rF9eV/Dafmr/LS
        T9wfeXArYdTVwpgrYiCcDxk4K6n1na/lBujSdXmYfsWIFT/XS8VJJgCKPsiNiI6KIOi6jmE
        7i0GdOCpBU8+PSswXZtftWGPRwU6tv6gRFoMpiakf/q85EuE9Q6hg09B6sAbP+MzsuyFua/
        6K7LAY3TjyzjwGuTU2oKsG7JMJ80Z7E5cxmPcaiyVbRhEpnDh10gHlZObF3fODLQT4rb0D3
        rj46+Ut2JWT8q4fsyIkm7QOlT7CWFYyvF7AXUxjtm58k9ARCerc/De4Pmt0bge379M6kI8d
        x4flyrn5r7kyD19dBM=
X-QQ-GoodBg: 0
From:   "Soha Jin" <soha@lohu.info>
To:     "'Andrew Lunn'" <andrew@lunn.ch>
Cc:     "'Giuseppe Cavallaro'" <peppe.cavallaro@st.com>,
        "'Alexandre Torgue'" <alexandre.torgue@foss.st.com>,
        "'Jose Abreu'" <joabreu@synopsys.com>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Eric Dumazet'" <edumazet@google.com>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'Paolo Abeni'" <pabeni@redhat.com>,
        "'Yangyu Chen'" <cyy@cyyself.name>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20221009162247.1336-1-soha@lohu.info> <20221009162247.1336-2-soha@lohu.info> <Y0SCuaVpAnbpMk72@lunn.ch>
In-Reply-To: <Y0SCuaVpAnbpMk72@lunn.ch>
Subject: RE: [PATCH 1/3] net: stmmac: use fwnode instead of of to configure driver
Date:   Tue, 11 Oct 2022 11:12:45 +0800
Message-ID: <9A100E763AFC9404+3a9901d8dd1f$56f01950$04d04bf0$@lohu.info>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJxQqkR5RuhsNy+BNQSBVWkkSX94gMmvIsjAXECYuassvHjgA==
Content-Language: fr
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpipv:lohu.info:qybglogicsvr:qybglogicsvr3
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,RCVD_ILLEGAL_IP,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Tuesday, October 11, 2022 4:38 AM
> 
> None of these are documented as being valid in ACPI. Do you need to ensure
> they only come from DT, or you document them for ACPI, and get the ACPI
> maintainers to ACK that they are O.K.

There is _DSD object in ACPI which is used to define Device Specific Data,
and provide additional properties and information to the driver. With
specific UUID listed in _DSD, a package can be used like Device Tree (a
string key associated with a value), and this is also the object
fwnode_property_* will parse with.

I have tested some of properties with a device describing stmmac device in
ACPI, and it works. These properties should be the configuration to the
driver, and is not related to the way configuring it. Moreover, these are
described in _DSD and not a part of ACPI standard, there seems no need to
ask ACPI maintainers.

Also, as described in Documentation/firmware-guide/acpi/enumeration.rst,
there is a Device Tree Namespace Link HID (PRP0001) in kernel. PRP0001 can
be used to describe a Device Tree in ACPI's _DSD object, and it just put DT
properties in a _DSD package with the specific UUID I said above. But to
utilize this feature, the driver seems need to use fwnode APIs.

> Backward compatibility only applies to DT. Anybody using ACPI should not
> expect any backwards compatibility, they should be documented mandatory
> properties right from the beginning.

Just do not want to mix the use of OF and fwnode APIs, I simply changed all
OF property APIs with fwnode APIs. If you really think the backward
compatibility should not exist in ACPI, I will change these compatible
codes back to OF APIs.

Regards,
Soha

