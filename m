Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8548858001
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 12:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbfF0KPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 06:15:39 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:39288 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbfF0KPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 06:15:39 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190627101536euoutp011d201b760568346b097c5826a53f0d13~sBrML_jnq0554205542euoutp017
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 10:15:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190627101536euoutp011d201b760568346b097c5826a53f0d13~sBrML_jnq0554205542euoutp017
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1561630536;
        bh=bxFnqa+gaX8KmJ5gHPf/pUQVZxLmoOj5+HSflVCgAGs=;
        h=From:To:Cc:Subject:Date:References:From;
        b=e9EAO+mreRXgTRtmJmTUZFf6WvCCpBB9XBIQgtI+zSFMhir4Qe9UBmWIJPDvNMmWH
         5nXKtYlBIO2LUxQQ8CRRyOzLq4/f9jAS3lAPKMQfgcxul0mzSABjsgL/KYZcQXZFIn
         +E8dYZDqCEm6Mxx6V9K0p8HCTYPkdqC71dRM+qP4=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190627101535eucas1p1f06095434888e38115ff6854ffe74c70~sBrLRFIBf1062510625eucas1p1w;
        Thu, 27 Jun 2019 10:15:35 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 14.5C.04325.747941D5; Thu, 27
        Jun 2019 11:15:35 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190627101535eucas1p27da11c25b0e15474e4c957053de139d9~sBrKmEPvo2154921549eucas1p2y;
        Thu, 27 Jun 2019 10:15:35 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190627101534eusmtrp21aac3f20f0c9fc6301a40ab5de83a046~sBrKX_EFP2684426844eusmtrp2Z;
        Thu, 27 Jun 2019 10:15:34 +0000 (GMT)
X-AuditID: cbfec7f5-b8fff700000010e5-7e-5d1497474dd6
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 76.3E.04140.647941D5; Thu, 27
        Jun 2019 11:15:34 +0100 (BST)
Received: from imaximets.rnd.samsung.ru (unknown [106.109.129.180]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190627101534eusmtip11973e4335bb9d20dd7726864d937381a~sBrJp3Mb-0975409754eusmtip1D;
        Thu, 27 Jun 2019 10:15:34 +0000 (GMT)
From:   Ilya Maximets <i.maximets@samsung.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        xdp-newbies@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ilya Maximets <i.maximets@samsung.com>
Subject: [PATCH bpf v5 0/2] xdp: fix hang while unregistering device bound
 to xdp socket
Date:   Thu, 27 Jun 2019 13:15:27 +0300
Message-Id: <20190627101529.11234-1-i.maximets@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42LZduznOV336SKxBu86VSz+tG1gtPh85Dib
        xeKF35gt5pxvYbG40v6T3eLYixY2i13rZjJbXN41h81ixaETQLEFYhbb+/cxOnB7bFl5k8lj
        56y77B6L97xk8ui6cYnZY3r3Q2aPvi2rGD0+b5ILYI/isklJzcksSy3St0vgymjYe5ex4A1b
        xaX2jWwNjBNYuxg5OSQETCQm7Z/H0sXIxSEksIJR4sv+2ewQzhdGibbzz1ghnM+MEqsaX7LA
        tPSdWM8GkVjOKPHr4B+oqh+MEn86FoANZhPQkTi1+ggjiC0iICXxccd2sLnMAjOZJbY8ngI2
        SlggSuJ3xwIwm0VAVeL6yy1gNq+AtcSd5iNMEOvkJVZvOMAM0iwh8JtN4vKcrcwQCReJ2e2b
        oWxhiVfHt7BD2DIS/3fOh2qul7jf8pIRormDUWL6oX9QCXuJLa/PATVwAJ2kKbF+lz5E2FHi
        /uwfzCBhCQE+iRtvBUHCzEDmpG3TocK8Eh1tQhDVKhK/Dy6HukBK4ua7z1AXeEisa9wFZgsJ
        xEpsbNrOPoFRbhbCrgWMjKsYxVNLi3PTU4uN81LL9YoTc4tL89L1kvNzNzECE8npf8e/7mDc
        9yfpEKMAB6MSD++KncKxQqyJZcWVuYcYJTiYlUR488NEYoV4UxIrq1KL8uOLSnNSiw8xSnOw
        KInzVjM8iBYSSE8sSc1OTS1ILYLJMnFwSjUwbpv0nonxv/CqOW5VR2oDrS8/FatIqd1x/DDX
        93gBbpeZr7K5LOdP6Tx6sP3jws6ry4sfnJp+0VbjnOOSdamfim5LxZ6vMhQ/sNr3ubSFsNBS
        eenLfbeDv328/+fltIlJV3Wj3lXt+9b7YNIaw509Yd+rO7q+1K/NnbG33JUjIFos6kH7vKXP
        JiixFGckGmoxFxUnAgByL5ssIAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t/xu7pu00ViDZa9M7H407aB0eLzkeNs
        FosXfmO2mHO+hcXiSvtPdotjL1rYLHatm8lscXnXHDaLFYdOAMUWiFls79/H6MDtsWXlTSaP
        nbPusnss3vOSyaPrxiVmj+ndD5k9+rasYvT4vEkugD1Kz6Yov7QkVSEjv7jEVina0MJIz9DS
        Qs/IxFLP0Ng81srIVEnfziYlNSezLLVI3y5BL6Nh713GgjdsFZfaN7I1ME5g7WLk5JAQMJHo
        O7GerYuRi0NIYCmjxIOvNxkhElISP35dgCoSlvhzrQuq6BujxIXpW8CK2AR0JE6tPgJmiwA1
        fNyxnR3EZhZYyCzxZZIJiC0sECFx98V3JhCbRUBV4vrLLSwgNq+AtcSd5iNMEAvkJVZvOMA8
        gZFnASPDKkaR1NLi3PTcYiO94sTc4tK8dL3k/NxNjMDw3Xbs55YdjF3vgg8xCnAwKvHwrtgp
        HCvEmlhWXJl7iFGCg1lJhDc/TCRWiDclsbIqtSg/vqg0J7X4EKMp0PKJzFKiyfnA2MoriTc0
        NTS3sDQ0NzY3NrNQEuftEDgYIySQnliSmp2aWpBaBNPHxMEp1cAowR744OXCXz/3aHdumLvd
        1fbnm4/ebyz/fNnAdnH3/PZEZi1GIbfXwrvrs5JMve8LZc+wDr5So1yuu/rszEk1Cxq7Dy/V
        dSyRsV4Q+cDd/cKCmbsdpJ4fe7A67vGPjDhLzsobZyOmXJRKfbx498RjlwyXzUyQKT+Wae9S
        ka4bFRnoy22lEeinxFKckWioxVxUnAgAFa49QXUCAAA=
X-CMS-MailID: 20190627101535eucas1p27da11c25b0e15474e4c957053de139d9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190627101535eucas1p27da11c25b0e15474e4c957053de139d9
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190627101535eucas1p27da11c25b0e15474e4c957053de139d9
References: <CGME20190627101535eucas1p27da11c25b0e15474e4c957053de139d9@eucas1p2.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Version 5:

    * Fixed incorrect handling of rtnl_lock.

Version 4:

    * 'xdp_umem_clear_dev' exposed to be used while unregistering.
    * Added XDP socket state to track if resources already unbinded.
    * Splitted in two fixes.

Version 3:

    * Declaration lines ordered from longest to shortest.
    * Checking of event type moved to the top to avoid unnecessary
      locking.

Version 2:

    * Completely re-implemented using netdev event handler.

Ilya Maximets (2):
  xdp: hold device for umem regardless of zero-copy mode
  xdp: fix hang while unregistering device bound to xdp socket

 include/net/xdp_sock.h |  5 +++
 net/xdp/xdp_umem.c     | 21 +++++-----
 net/xdp/xdp_umem.h     |  1 +
 net/xdp/xsk.c          | 87 ++++++++++++++++++++++++++++++++++++------
 4 files changed, 93 insertions(+), 21 deletions(-)

-- 
2.17.1

