Return-Path: <netdev+bounces-6733-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C20C717AE7
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 10:59:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBE0028145C
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 08:59:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAD18BE6E;
	Wed, 31 May 2023 08:58:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75602BE70
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 08:58:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21EFCC4339C;
	Wed, 31 May 2023 08:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685523518;
	bh=mJSo8BBhwI/dxw8GdROOGb5gjgq5W1wrGSLzQKQwoBM=;
	h=From:To:Cc:Subject:Date:From;
	b=EdgHBh4fKoarUjaCHDjrTETCm9eZRtZK+xB4AF1Cvyzt8RfhXhvfpaI39jYisNGel
	 W+1HCggsHBWceZ+Wbd/KdUfbPmF6jywdVc49MKy+6LtxnZYzank29gYJh8Yjnm72HR
	 vnIvAFUIM51knHrRGnCdp/UdStJKvbSIsem/YbdfN2tFUZ2H11UB1OpMz7eZNo8dU7
	 t/FDcSmg6o4Ji/IcGysS32iTV+6O25M7sJpMFOVmtFXdcdYyhqDdw5I2pPamrtIA+U
	 qLIm1/9xqFneZmU5u5Ys37xbGukQj5AEcSQ68iZJHxMq5X3aCH8zmJVt/0ceSN1WYv
	 vtPKAv85S5MSA==
Received: from johan by xi.lan with local (Exim 4.94.2)
	(envelope-from <johan+linaro@kernel.org>)
	id 1q4HfE-0000jj-Ss; Wed, 31 May 2023 10:58:41 +0200
From: Johan Hovold <johan+linaro@kernel.org>
To: Marcel Holtmann <marcel@holtmann.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH RESEND 0/2] Bluetooth: fix debugfs registration
Date: Wed, 31 May 2023 10:57:57 +0200
Message-Id: <20230531085759.2803-1-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The HCI controller debugfs interface is created during setup or when a
controller is configured, but there is nothing preventing a controller
from being configured multiple times (e.g. by setting the device
address), which results in a host of errors in the logs:

	debugfs: File 'features' in directory 'hci0' already present!
	debugfs: File 'manufacturer' in directory 'hci0' already present!
	debugfs: File 'hci_version' in directory 'hci0' already present!
	...
	debugfs: File 'quirk_simultaneous_discovery' in directory 'hci0' already present!

The Qualcomm driver suffers from a related problem for controllers with
non-persistent setup.

Johan


Johan Hovold (2):
  Bluetooth: fix debugfs registration
  Bluetooth: hci_qca: fix debugfs registration

 drivers/bluetooth/hci_qca.c | 6 +++++-
 include/net/bluetooth/hci.h | 1 +
 net/bluetooth/hci_sync.c    | 3 +++
 3 files changed, 9 insertions(+), 1 deletion(-)

-- 
2.39.3


