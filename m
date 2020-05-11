Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71FE1CD990
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 14:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbgEKMYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 08:24:07 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:39376 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725913AbgEKMYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 08:24:05 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.143])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 4BFEC200AE;
        Mon, 11 May 2020 12:24:04 +0000 (UTC)
Received: from us4-mdac16-24.at1.mdlocal (unknown [10.110.49.206])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 4D1CF8009B;
        Mon, 11 May 2020 12:24:04 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.106])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D62144006C;
        Mon, 11 May 2020 12:24:03 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 969FCB40066;
        Mon, 11 May 2020 12:24:03 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 11 May
 2020 13:23:58 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 0/8] sfc: remove nic_data usage in common code
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
Message-ID: <8154dba6-b312-7dcf-7d49-cd6c6801ffc2@solarflare.com>
Date:   Mon, 11 May 2020 13:23:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25412.003
X-TM-AS-Result: No-1.850600-8.000000-10
X-TMASE-MatchedRID: BbQmvhT5U4dzkdIIrJMD7YS/TV9k6ppACZ33+gDEJw1TorRIuadptB5d
        UAxwPy+5CujquDdjAza6cFiwF3UwlVtWXpLuutLTuoibJpHRrFlXjjsM2/DfxmAMM0WKD4asJBZ
        iivO+i6NHjZbwyo4ECJohTboG2IV3Wfk+auVwzBsJaVZHbbd1rnFa/hQHt1A1u+tgTIyLDDiFR9
        s3K3Ofub6uImWdqYmDU71X33iML0MFHH1v6HnZqp4CIKY/Hg3AtOt1ofVlaoJlgn288nW9IAuTL
        po5HEc1joczmuoPCq2KD6GMKtcCFBxB6vSkHQyhKzOz6qrvZKeKNilj756Tgha6RcK318553ttQ
        x6EeeB4ziGE5/pJP8vVNg70BPyPONq55WNwQHyYXxY6mau8LG3IJh4dBcU42f4hpTpoBF9JqxGC
        SzFD9MrEvnlrhVRa7lExlQIQeRG0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-1.850600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25412.003
X-MDID: 1589199844-cjdUJyZn-BNH
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

efx->nic_data should only be used from NIC-specific code (i.e. nic_type
 functions and things they call), in files like ef10[_sriov].c and
 siena.c.  This series refactors several nic_data usages from common
 code (mainly in mcdi_filters.c) into nic_type functions, in preparation
 for the upcoming ef100 driver which will use those functions but have
 its own struct layout for efx->nic_data distinct from ef10's.
After this series, one nic_data usage (in ptp.c) remains; it wasn't
 clear to me how to fix it, and ef100 devices don't yet have PTP support
 (so the initial ef100 driver will not call that code).

Edward Cree (7):
  sfc: move vport_id to struct efx_nic
  sfc: use efx_has_cap for capability checks outside of NIC-specific
    code
  sfc: move 'must restore' flags out of ef10-specific nic_data
  sfc: rework handling of (firmware) multicast chaining state
  sfc: move rx_rss_context_exclusive into struct efx_mcdi_filter_table
  sfc: make filter table probe caller responsible for adding VLANs
  sfc: make firmware-variant printing a nic_type function

Tom Zhao (1):
  sfc: make capability checking a nic_type function

 drivers/net/ethernet/sfc/ef10.c           | 214 +++++++++++++---------
 drivers/net/ethernet/sfc/ef10_sriov.c     |  27 ++-
 drivers/net/ethernet/sfc/mcdi.c           |  25 +--
 drivers/net/ethernet/sfc/mcdi.h           |  12 ++
 drivers/net/ethernet/sfc/mcdi_filters.c   |  79 ++++----
 drivers/net/ethernet/sfc/mcdi_filters.h   |  17 +-
 drivers/net/ethernet/sfc/mcdi_functions.c |   8 +-
 drivers/net/ethernet/sfc/mcdi_port.c      |   7 +-
 drivers/net/ethernet/sfc/net_driver.h     |  10 +
 drivers/net/ethernet/sfc/nic.h            |  11 --
 drivers/net/ethernet/sfc/ptp.c            |   7 +-
 drivers/net/ethernet/sfc/siena.c          |   7 +
 12 files changed, 238 insertions(+), 186 deletions(-)

