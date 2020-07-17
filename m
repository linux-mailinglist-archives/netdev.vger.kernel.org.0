Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09F022429C
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 19:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgGQRv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 13:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbgGQRv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 13:51:58 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C73C0619D2
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 10:51:57 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id b6so12003770wrs.11
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 10:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=IE32Y40SA5j515K0SV4oNXBQe+0QT1TftVMsK6XHxDc=;
        b=mLcJ5OJxRTFA6j+0yBkhtP5kp1FLRoCUtYhwYI1g6jxd2to2FYnu1JZ+U4wtYdhLvU
         YxGduSNrmv2U6kWm8eStvAOxyhOI1AJfy2BQ+mrQU/SK3xpQYIBQ1bRfx6uM5BXTym0i
         wyCla90ZwOiapKbGMqHizdkJNlU0ffRV8arOLx+81icb/RTrfwXorhABL0fbggTZKpKH
         Ra0SSKaLOB/CFc2oZSkgeVSPTVvMizbmcwDQ0Hayp2wYU0ud2ylL7DHZDFcmNXIGop2y
         F703XEvsKiO43PzQPOUBg2tvCRESXVgPCJwu6xQN4gaJpxa4CrB5quFap0yJeTw4OtBc
         aAKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=IE32Y40SA5j515K0SV4oNXBQe+0QT1TftVMsK6XHxDc=;
        b=a9XdMiNm0cKaeZdyt6cnIWQ2DbWnauIe4zAp+hvTxa2hO8Bs340lRNrWuyrbEWsG/Q
         XmfbYBOIhzuMlHHQoJyif0L0RUBTKg66kMLxacpGxb+EtAjhGJUzu7SrSuOyQ817IT6x
         PjV7YUAT14mrfggAuzv3jpPxYxRWuaabAccfsHEiIHhUJOOFpa8Z6ICKyT3L0Vbb+z5A
         aAEz9MNOO7JsfW7F6EN3nW+dstnw8qm6XtATx1y1QBsXk40qousQBZGZeVyrO45HRvnE
         OqTnyA7ixkGcwLAXe8tqjJnhV2RmKWescucN/xxXmGVuADRZmL/GtRzt0ZRvUnvaVCqd
         9Quw==
X-Gm-Message-State: AOAM532SuLcp1yqgircLQGwrmJyZi2J94goJNCo2Go8CFWzZ7m+Cj7/I
        vQwVHJKpgcqNSMU6X3cD2BlUA5EvbqXZolZ/fUerWpVeisE=
X-Google-Smtp-Source: ABdhPJwxxkTisAJvaOexyfxhlH2DXxfOvsNGFiq3fZt0TUl5kPHBtEygmy6WGiyS9DtMypU+Ri9hU9jOG5BoiH77Eaw=
X-Received: by 2002:adf:f083:: with SMTP id n3mr11470936wro.297.1595008314890;
 Fri, 17 Jul 2020 10:51:54 -0700 (PDT)
MIME-Version: 1.0
From:   Matt Sandy <mooseboys@gmail.com>
Date:   Fri, 17 Jul 2020 10:51:43 -0700
Message-ID: <CAPGpzNf5oRy7Vuesi2Y_aVj_B66ZUsQRKk+yQAF9g8TbASj=3Q@mail.gmail.com>
Subject: Unexpected PACKET_TX_TIMESTAMP Messages
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've been playing around with raw sockets and timestamps, but seem to
be getting strange timestamp data back on the errqueue. Specifically,
if I am creating a socket(AF_PACKET, SOCK_RAW, htons(ETH_P_IP)) and
requesting SO_TIMESTAMPING_NEW with options 0x4DF. I am not modifying
the flags with control messages.

On both send and receive, I get the expected
SOL_SOCKET/SO_TIMESTAMPING_NEW cmsg (in errqueue on send, in the
message itself on receive), and it contains what appears to be valid
timestamps in the ts[0] field. On send, however, I receive an
additional cmsg with level = SOL_PACKET/PACKET_TX_TIMESTAMP, whose
content is just the fixed value `char[16] { 42, 0, 0, 0, 4, <zeros>
}`.

Any ideas why I'd be getting the SOL_PACKET message on transmit, and
why its payload is clearly not a valid timestamp? In case it matters,
this is on an Intel I210 nic using the igb driver.
