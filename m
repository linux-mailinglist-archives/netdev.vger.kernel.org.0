Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944183CEA30
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 19:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345966AbhGSRIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 13:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376916AbhGSRGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 13:06:18 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A5BC061768
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 10:27:12 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id f17so23072064wrt.6
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 10:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nuviainc-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=ZaikZsvoK6lLpb01OOlADOahkWAxyqrN9dBXLPWPnY4=;
        b=P/Ac/6PhXSVFFGJQhoKhkhTHqZG274nJlcy2oNDDvoQJeg2yN929Emomy73VMeSoWK
         t9jG2tNKfymlb5tROa0HBVX2Drbl2Sb8PifPXwrRi3zbdJ94w0CLqudcSYjdMOMIxn96
         fgh++qOJ46VFpzds45V1tgZjWuXV7+xcjNWoMr0jrKjLqGifra18SR3znuHHz2a4Wv3e
         1j14kfpQz18HsOpztqeTNdpApKDtYsCEGQzr11wzw0PDn3uZPlbbxKKQQyBR5UeLjLRc
         r2pReJQGBulMipXCj4zMqV6LDz5il7sdGngpISSsLeaDxPJ4MhZYKmiq6ZTkyCXtMvh+
         m9zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=ZaikZsvoK6lLpb01OOlADOahkWAxyqrN9dBXLPWPnY4=;
        b=oxQqXeoHVlV90nCg6Dq64lgTiW+1id+4/oKayNUsfyeCytTHa8mYn5qB5BQrSJtxAT
         p8lrtQaALNuJNaJXUoLAOJhaW9Uot4UUEq+GY/S1b4/PJQ7A3b87TSlSrz339KqTx6ND
         waqDmJk7t+Drb+HkGSAkv0Oj7nG5n17hdzx2jGi6/pEa+PDVBd8Jm4bufGgX/DmYfE6z
         5OFqu8SKo2BOoRKM0CvfN50esXx3/6sr1/POA2DjTv8Q8WE8p3ergPyioYbJ4K9V92Hq
         thrGWnyVoPIHIkeaIGDgE3hLAQt3JkOQAHcXa7+WuPx9beqbGy4YLDh9vNSHkVz+B9f5
         swLA==
X-Gm-Message-State: AOAM533WLvkRTfEuGMny2v0cTttN2u56pcUzbpp1CqsZV04Jqf8iLpa4
        6Ge3dvrl4CvDUGpnWVnyuQ3cnI8E2d1xBQ==
X-Google-Smtp-Source: ABdhPJx+V7k3TQaQ+13j68jhPU5QwT0XQei9zN8DqQ6bn2vwXl/uc5A85TTRFeBkT0rXTN4XG7NaPg==
X-Received: by 2002:a5d:408a:: with SMTP id o10mr30313480wrp.272.1626716672298;
        Mon, 19 Jul 2021 10:44:32 -0700 (PDT)
Received: from localhost ([82.44.17.50])
        by smtp.gmail.com with ESMTPSA id p5sm23112012wrd.25.2021.07.19.10.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 10:44:31 -0700 (PDT)
Date:   Mon, 19 Jul 2021 18:44:30 +0100
From:   Jamie Iles <jamie@nuviainc.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com
Cc:     netdev@vger.kernel.org
Subject: IXGBE VF DMA error handling bug(?)
Message-ID: <YPW5/jndPPpnpWYo@hazel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi folks,

Whilst reviewing the IXGBE driver I found a potential bug for VF DMA 
error handling.

83c61fa97a7d ("ixgbe: Add protection from VF invalid target DMA") added 
a workaround for an invalid VF DMA address that would read the TLP 
header from the PCIe RP to get the requester ID and then reset the 
originating VF.  144384649dc1 ("ixgbe: Check config reads for removal") 
then added checks for removal when performing config accesses, but 
changed:

 bdev = pdev->bus->self;                                        
 while (bdev && (pci_pcie_type(bdev) != PCI_EXP_TYPE_ROOT_PORT))
         bdev = bdev->bus->self;                                

...

-       pci_read_config_dword(bdev, pos + PCI_ERR_HEADER_LOG, &dw0);      
-       pci_read_config_dword(bdev, pos + PCI_ERR_HEADER_LOG + 4, &dw1);  
-       pci_read_config_dword(bdev, pos + PCI_ERR_HEADER_LOG + 8, &dw2);  
-       pci_read_config_dword(bdev, pos + PCI_ERR_HEADER_LOG + 12, &dw3); 
+       dw0 = ixgbe_read_pci_cfg_dword(hw, pos + PCI_ERR_HEADER_LOG);     
+       dw1 = ixgbe_read_pci_cfg_dword(hw, pos + PCI_ERR_HEADER_LOG + 4); 
+       dw2 = ixgbe_read_pci_cfg_dword(hw, pos + PCI_ERR_HEADER_LOG + 8); 
+       dw3 = ixgbe_read_pci_cfg_dword(hw, pos + PCI_ERR_HEADER_LOG + 12);

so now the header is being read from NIC config space rather than the 
root port.

If correct, the fix should be as simple as reverting those accessor 
changes in ixgbe_io_error_detected.

Thanks,

Jamie
