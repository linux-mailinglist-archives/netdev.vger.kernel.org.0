Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C5B1FCE5C
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 15:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgFQN1T convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 17 Jun 2020 09:27:19 -0400
Received: from SMTP01.itecon.de ([80.242.182.181]:29448 "EHLO
        webmail.first-class-email.de" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725901AbgFQN1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 09:27:19 -0400
X-Greylist: delayed 323 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Jun 2020 09:27:19 EDT
Received: from S11085.first-class-email.de (10.1.80.101) by
 S10006.first-class-email.de (192.168.2.156) with Microsoft SMTP Server (TLS)
 id 8.3.485.1; Wed, 17 Jun 2020 15:21:53 +0200
Received: from pm-tm-ubuntu (77.179.29.219) by webmail.first-class-email.de
 (10.1.80.101) with Microsoft SMTP Server (TLS) id 14.3.487.0; Wed, 17 Jun
 2020 15:21:53 +0200
Date:   Wed, 17 Jun 2020 15:21:53 +0200
From:   Tanjeff-Nicolai Moos <tmoos@eltec.de>
To:     <netdev@vger.kernel.org>
Subject: qmi_wwan not using netif_carrier_*()
Message-ID: <20200617152153.2e66ccaf@pm-tm-ubuntu>
Organization: ELTEC
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [77.179.29.219]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi netdevs,

Kernel version:

  I'm working with kernel 4.14.137 (OpenWRT project). But I looked at
  the source of kernel 5.7 and found the same situation.

Problem:

  I'm using the qmi_wwan driver for a Sierra Wireless EM7455 LTE
  modem. This driver does not use
  netif_carrier_on()/netif_carrier_off() to update its link status.
  This confuses ledtrig_netdev which uses netif_carrier_ok() to obtain
  the link status.

My solution:

  As a solution (or workaround?) I would try:

  1) In drivers/net/usb/qmi_wwan.c, lines 904/913: Add the flag
     FLAG_LINK_INTR.

  2) In drivers/net/usb/usbnet.c, functions usbnet_open() and
     usbnet_stop(): Add a call to netif_carrier_*(),
     but only if FLAG_LINK_INTR is set.

Question:

  Is this the intended way to use FLAG_LINK_INTR and netif_carrier_*()?
  Or is there another recommended way to obtain the link status of
  network devices (I could change ledtrig_netdev)?


Kind regards, tanjeff

--

Tanjeff-Nicolai Moos
Dipl.-Inf. (FH)
Senior Software Engineer

ELTEC Elektronik AG, Mainz
_________________________

Fon     +49 6131 918 342
Fax     +49 6131 918 195
Email   tmoos@eltec.de
Web     www.eltec.de

________________________________


*********************************************************
ELTEC Elektronik AG
Galileo-Galilei-Straße 11
D-55129 Mainz

Vorstand: Peter Albert
Aufsichtsratsvorsitzender: Andreas Kochhäuser

Registergericht: Amtsgericht Mainz
Registernummer: HRB 7038
Ust-ID: DE 149 049 790
*********************************************************
Wichtiger Hinweis:
Diese E-Mail kann Betriebs- oder Geschäftsgeheimnisse oder sonstige vertrauliche Informationen enthalten. Sollten Sie diese E-Mail irrtümlich erhalten haben, ist Ihnen eine Kenntnisnahme des Inhalts, eine Vervielfältigung oder Weitergabe der E-Mail ausdrücklich untersagt.
Bitte benachrichtigen Sie uns und vernichten Sie die empfangene E-Mail. Evtl. Anhänge dieser Nachricht wurden auf Viren überprüft!
Jede Form von Vervielfältigung, Abänderung, Verbreitung oder Veröffentlichung dieser E-Mail Nachricht ist untersagt! Das Verwenden von Informationen aus dieser Nachricht für irgendwelche Zwecke ist strengstens untersagt.
Es gelten unsere Allgemeinen Geschäftsbedingungen, zu finden unter www.eltec.de.
