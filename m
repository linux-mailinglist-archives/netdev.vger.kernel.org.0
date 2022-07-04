Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1F93565447
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 14:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233616AbiGDMEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 08:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232279AbiGDMEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 08:04:32 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 695CF26D5;
        Mon,  4 Jul 2022 05:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656936271; x=1688472271;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=z0HmVad+q8PKfl4PrtrxlmtwFc4pa///vsAqHiF/5bI=;
  b=ZLwwcuGhoQ8g1zQdCo5YeFJVmVBSRmeeeW06/fogFZSAY5qrcotaagSX
   mEtTu4bGPYxGH0WJDjj/cx6+nvu/eW/8+v9ZIyEiOm03aRBNBqvOobPDf
   vaXAai+/0Ju2pwB67kCb52MukpP3yA1CpB1T+FddGlE0d9ovgEMVp5ONu
   YTM741dOuagueTnJco8RtYQKpqrR/UGA+AVMn4OuPjnQzNtRcdtNbHZX/
   roKA8qFraAL9M/b7/E651ZsNk5Gzr43t9Vffb/01DFWm9JafSqvK4Ix+X
   yuqJdkWBNlrwOV4fDDmNAPbWLkySLHGM/o18oYpn1028YiSp80x6nkXm0
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10397"; a="369437636"
X-IronPort-AV: E=Sophos;i="5.92,243,1650956400"; 
   d="scan'208";a="369437636"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2022 05:04:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,243,1650956400"; 
   d="scan'208";a="567204914"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 04 Jul 2022 05:04:27 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o8KoU-000Hr5-Sv;
        Mon, 04 Jul 2022 12:04:26 +0000
Date:   Mon, 4 Jul 2022 20:04:06 +0800
From:   kernel test robot <lkp@intel.com>
To:     Qiao Ma <mqaio@linux.alibaba.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, kuba@kernel.org,
        gustavoars@kernel.org, cai.huoqing@linux.dev,
        aviad.krawczyk@huawei.com, zhaochen6@huawei.com
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/3] net: hinic: fix bug that ethtool get
 wrong stats
Message-ID: <202207041952.aDY8T1Ew-lkp@intel.com>
References: <7e3115e81cd5cab71a4a79b8061062e9d25eb5af.1656921519.git.mqaio@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e3115e81cd5cab71a4a79b8061062e9d25eb5af.1656921519.git.mqaio@linux.alibaba.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Qiao,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Qiao-Ma/net-hinic-fix-three-bugs-about-dev_get_stats/20220704-165848
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git d0bf1fe6454e976e39bc1524b9159fa2c0fcf321
config: i386-allyesconfig (https://download.01.org/0day-ci/archive/20220704/202207041952.aDY8T1Ew-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/223573d76883c30f449fc9d1bd45a3c819f85dcc
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Qiao-Ma/net-hinic-fix-three-bugs-about-dev_get_stats/20220704-165848
        git checkout 223573d76883c30f449fc9d1bd45a3c819f85dcc
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/net/ethernet/huawei/hinic/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/huawei/hinic/hinic_main.c: In function 'nic_dev_init':
>> drivers/net/ethernet/huawei/hinic/hinic_main.c:1163:33: warning: unused variable 'rx_stats' [-Wunused-variable]
    1163 |         struct hinic_rxq_stats *rx_stats;
         |                                 ^~~~~~~~
>> drivers/net/ethernet/huawei/hinic/hinic_main.c:1162:33: warning: unused variable 'tx_stats' [-Wunused-variable]
    1162 |         struct hinic_txq_stats *tx_stats;
         |                                 ^~~~~~~~


vim +/rx_stats +1163 drivers/net/ethernet/huawei/hinic/hinic_main.c

a0337c0dee686a Luo bin            2020-06-28  1152  
51ba902a16e68b Aviad Krawczyk     2017-08-21  1153  /**
51ba902a16e68b Aviad Krawczyk     2017-08-21  1154   * nic_dev_init - Initialize the NIC device
51ba902a16e68b Aviad Krawczyk     2017-08-21  1155   * @pdev: the NIC pci device
51ba902a16e68b Aviad Krawczyk     2017-08-21  1156   *
51ba902a16e68b Aviad Krawczyk     2017-08-21  1157   * Return 0 - Success, negative - Failure
51ba902a16e68b Aviad Krawczyk     2017-08-21  1158   **/
51ba902a16e68b Aviad Krawczyk     2017-08-21  1159  static int nic_dev_init(struct pci_dev *pdev)
51ba902a16e68b Aviad Krawczyk     2017-08-21  1160  {
c4d06d2d208a6c Aviad Krawczyk     2017-08-21  1161  	struct hinic_rx_mode_work *rx_mode_work;
edd384f682cc29 Aviad Krawczyk     2017-08-21 @1162  	struct hinic_txq_stats *tx_stats;
edd384f682cc29 Aviad Krawczyk     2017-08-21 @1163  	struct hinic_rxq_stats *rx_stats;
51ba902a16e68b Aviad Krawczyk     2017-08-21  1164  	struct hinic_dev *nic_dev;
51ba902a16e68b Aviad Krawczyk     2017-08-21  1165  	struct net_device *netdev;
51ba902a16e68b Aviad Krawczyk     2017-08-21  1166  	struct hinic_hwdev *hwdev;
5e126e7c4e5275 Luo bin            2020-07-15  1167  	struct devlink *devlink;
4abd7cffc09a38 Jakub Kicinski     2021-10-15  1168  	u8 addr[ETH_ALEN];
51ba902a16e68b Aviad Krawczyk     2017-08-21  1169  	int err, num_qps;
51ba902a16e68b Aviad Krawczyk     2017-08-21  1170  
919d13a7e455c2 Leon Romanovsky    2021-08-08  1171  	devlink = hinic_devlink_alloc(&pdev->dev);
5e126e7c4e5275 Luo bin            2020-07-15  1172  	if (!devlink) {
5e126e7c4e5275 Luo bin            2020-07-15  1173  		dev_err(&pdev->dev, "Hinic devlink alloc failed\n");
c15850c709eb5c Luo bin            2020-07-25  1174  		return -ENOMEM;
5e126e7c4e5275 Luo bin            2020-07-15  1175  	}
5e126e7c4e5275 Luo bin            2020-07-15  1176  
c15850c709eb5c Luo bin            2020-07-25  1177  	hwdev = hinic_init_hwdev(pdev, devlink);
c15850c709eb5c Luo bin            2020-07-25  1178  	if (IS_ERR(hwdev)) {
c15850c709eb5c Luo bin            2020-07-25  1179  		dev_err(&pdev->dev, "Failed to initialize HW device\n");
c15850c709eb5c Luo bin            2020-07-25  1180  		hinic_devlink_free(devlink);
c15850c709eb5c Luo bin            2020-07-25  1181  		return PTR_ERR(hwdev);
c15850c709eb5c Luo bin            2020-07-25  1182  	}
5e126e7c4e5275 Luo bin            2020-07-15  1183  
51ba902a16e68b Aviad Krawczyk     2017-08-21  1184  	num_qps = hinic_hwdev_num_qps(hwdev);
51ba902a16e68b Aviad Krawczyk     2017-08-21  1185  	if (num_qps <= 0) {
51ba902a16e68b Aviad Krawczyk     2017-08-21  1186  		dev_err(&pdev->dev, "Invalid number of QPS\n");
51ba902a16e68b Aviad Krawczyk     2017-08-21  1187  		err = -EINVAL;
51ba902a16e68b Aviad Krawczyk     2017-08-21  1188  		goto err_num_qps;
51ba902a16e68b Aviad Krawczyk     2017-08-21  1189  	}
51ba902a16e68b Aviad Krawczyk     2017-08-21  1190  
51ba902a16e68b Aviad Krawczyk     2017-08-21  1191  	netdev = alloc_etherdev_mq(sizeof(*nic_dev), num_qps);
51ba902a16e68b Aviad Krawczyk     2017-08-21  1192  	if (!netdev) {
51ba902a16e68b Aviad Krawczyk     2017-08-21  1193  		dev_err(&pdev->dev, "Failed to allocate Ethernet device\n");
51ba902a16e68b Aviad Krawczyk     2017-08-21  1194  		err = -ENOMEM;
51ba902a16e68b Aviad Krawczyk     2017-08-21  1195  		goto err_alloc_etherdev;
51ba902a16e68b Aviad Krawczyk     2017-08-21  1196  	}
51ba902a16e68b Aviad Krawczyk     2017-08-21  1197  
1f62cfa19a619f Luo bin            2020-04-25  1198  	if (!HINIC_IS_VF(hwdev->hwif))
51ba902a16e68b Aviad Krawczyk     2017-08-21  1199  		netdev->netdev_ops = &hinic_netdev_ops;
1f62cfa19a619f Luo bin            2020-04-25  1200  	else
1f62cfa19a619f Luo bin            2020-04-25  1201  		netdev->netdev_ops = &hinicvf_netdev_ops;
7dd29ee1286547 Luo bin            2020-04-25  1202  
52f31422d462d1 Aviad Krawczyk     2017-08-28  1203  	netdev->max_mtu = ETH_MAX_MTU;
51ba902a16e68b Aviad Krawczyk     2017-08-21  1204  
51ba902a16e68b Aviad Krawczyk     2017-08-21  1205  	nic_dev = netdev_priv(netdev);
51ba902a16e68b Aviad Krawczyk     2017-08-21  1206  	nic_dev->netdev = netdev;
51ba902a16e68b Aviad Krawczyk     2017-08-21  1207  	nic_dev->hwdev  = hwdev;
51ba902a16e68b Aviad Krawczyk     2017-08-21  1208  	nic_dev->msg_enable = MSG_ENABLE_DEFAULT;
c4d06d2d208a6c Aviad Krawczyk     2017-08-21  1209  	nic_dev->flags = 0;
c3e79baf1b03b3 Aviad Krawczyk     2017-08-21  1210  	nic_dev->txqs = NULL;
c3e79baf1b03b3 Aviad Krawczyk     2017-08-21  1211  	nic_dev->rxqs = NULL;
00e57a6d4ad345 Aviad Krawczyk     2017-08-21  1212  	nic_dev->tx_weight = tx_weight;
e2585ea775380e Aviad Krawczyk     2017-08-21  1213  	nic_dev->rx_weight = rx_weight;
bcab67822d7714 Luo bin            2020-05-13  1214  	nic_dev->sq_depth = HINIC_SQ_DEPTH;
bcab67822d7714 Luo bin            2020-05-13  1215  	nic_dev->rq_depth = HINIC_RQ_DEPTH;
7dd29ee1286547 Luo bin            2020-04-25  1216  	nic_dev->sriov_info.hwdev = hwdev;
7dd29ee1286547 Luo bin            2020-04-25  1217  	nic_dev->sriov_info.pdev = pdev;
2eed5a8b614bc0 Luo bin            2020-06-02  1218  	nic_dev->max_qps = num_qps;
5e126e7c4e5275 Luo bin            2020-07-15  1219  	nic_dev->devlink = devlink;
51ba902a16e68b Aviad Krawczyk     2017-08-21  1220  
ea256222a46385 Luo bin            2020-06-28  1221  	hinic_set_ethtool_ops(netdev);
ea256222a46385 Luo bin            2020-06-28  1222  
25a3ba61060937 Aviad Krawczyk     2017-08-21  1223  	sema_init(&nic_dev->mgmt_lock, 1);
25a3ba61060937 Aviad Krawczyk     2017-08-21  1224  
7c2c57263af41c Christophe JAILLET 2022-06-26  1225  	nic_dev->vlan_bitmap = devm_bitmap_zalloc(&pdev->dev, VLAN_N_VID,
25a3ba61060937 Aviad Krawczyk     2017-08-21  1226  						  GFP_KERNEL);
25a3ba61060937 Aviad Krawczyk     2017-08-21  1227  	if (!nic_dev->vlan_bitmap) {
25a3ba61060937 Aviad Krawczyk     2017-08-21  1228  		err = -ENOMEM;
25a3ba61060937 Aviad Krawczyk     2017-08-21  1229  		goto err_vlan_bitmap;
25a3ba61060937 Aviad Krawczyk     2017-08-21  1230  	}
25a3ba61060937 Aviad Krawczyk     2017-08-21  1231  
c4d06d2d208a6c Aviad Krawczyk     2017-08-21  1232  	nic_dev->workq = create_singlethread_workqueue(HINIC_WQ_NAME);
c4d06d2d208a6c Aviad Krawczyk     2017-08-21  1233  	if (!nic_dev->workq) {
c4d06d2d208a6c Aviad Krawczyk     2017-08-21  1234  		err = -ENOMEM;
c4d06d2d208a6c Aviad Krawczyk     2017-08-21  1235  		goto err_workq;
c4d06d2d208a6c Aviad Krawczyk     2017-08-21  1236  	}
c4d06d2d208a6c Aviad Krawczyk     2017-08-21  1237  
51ba902a16e68b Aviad Krawczyk     2017-08-21  1238  	pci_set_drvdata(pdev, netdev);
51ba902a16e68b Aviad Krawczyk     2017-08-21  1239  
4abd7cffc09a38 Jakub Kicinski     2021-10-15  1240  	err = hinic_port_get_mac(nic_dev, addr);
7dd29ee1286547 Luo bin            2020-04-25  1241  	if (err) {
7dd29ee1286547 Luo bin            2020-04-25  1242  		dev_err(&pdev->dev, "Failed to get mac address\n");
7dd29ee1286547 Luo bin            2020-04-25  1243  		goto err_get_mac;
7dd29ee1286547 Luo bin            2020-04-25  1244  	}
4abd7cffc09a38 Jakub Kicinski     2021-10-15  1245  	eth_hw_addr_set(netdev, addr);
7dd29ee1286547 Luo bin            2020-04-25  1246  
7dd29ee1286547 Luo bin            2020-04-25  1247  	if (!is_valid_ether_addr(netdev->dev_addr)) {
7dd29ee1286547 Luo bin            2020-04-25  1248  		if (!HINIC_IS_VF(nic_dev->hwdev->hwif)) {
7dd29ee1286547 Luo bin            2020-04-25  1249  			dev_err(&pdev->dev, "Invalid MAC address\n");
7dd29ee1286547 Luo bin            2020-04-25  1250  			err = -EIO;
7dd29ee1286547 Luo bin            2020-04-25  1251  			goto err_add_mac;
7dd29ee1286547 Luo bin            2020-04-25  1252  		}
7dd29ee1286547 Luo bin            2020-04-25  1253  
7dd29ee1286547 Luo bin            2020-04-25  1254  		dev_info(&pdev->dev, "Invalid MAC address %pM, using random\n",
7dd29ee1286547 Luo bin            2020-04-25  1255  			 netdev->dev_addr);
7dd29ee1286547 Luo bin            2020-04-25  1256  		eth_hw_addr_random(netdev);
7dd29ee1286547 Luo bin            2020-04-25  1257  	}
25a3ba61060937 Aviad Krawczyk     2017-08-21  1258  
25a3ba61060937 Aviad Krawczyk     2017-08-21  1259  	err = hinic_port_add_mac(nic_dev, netdev->dev_addr, 0);
7dd29ee1286547 Luo bin            2020-04-25  1260  	if (err && err != HINIC_PF_SET_VF_ALREADY) {
25a3ba61060937 Aviad Krawczyk     2017-08-21  1261  		dev_err(&pdev->dev, "Failed to add mac\n");
25a3ba61060937 Aviad Krawczyk     2017-08-21  1262  		goto err_add_mac;
25a3ba61060937 Aviad Krawczyk     2017-08-21  1263  	}
25a3ba61060937 Aviad Krawczyk     2017-08-21  1264  
25a3ba61060937 Aviad Krawczyk     2017-08-21  1265  	err = hinic_port_set_mtu(nic_dev, netdev->mtu);
25a3ba61060937 Aviad Krawczyk     2017-08-21  1266  	if (err) {
25a3ba61060937 Aviad Krawczyk     2017-08-21  1267  		dev_err(&pdev->dev, "Failed to set mtu\n");
25a3ba61060937 Aviad Krawczyk     2017-08-21  1268  		goto err_set_mtu;
25a3ba61060937 Aviad Krawczyk     2017-08-21  1269  	}
25a3ba61060937 Aviad Krawczyk     2017-08-21  1270  
c4d06d2d208a6c Aviad Krawczyk     2017-08-21  1271  	rx_mode_work = &nic_dev->rx_mode_work;
c4d06d2d208a6c Aviad Krawczyk     2017-08-21  1272  	INIT_WORK(&rx_mode_work->work, set_rx_mode);
c4d06d2d208a6c Aviad Krawczyk     2017-08-21  1273  
25a3ba61060937 Aviad Krawczyk     2017-08-21  1274  	netdev_features_init(netdev);
25a3ba61060937 Aviad Krawczyk     2017-08-21  1275  
51ba902a16e68b Aviad Krawczyk     2017-08-21  1276  	netif_carrier_off(netdev);
51ba902a16e68b Aviad Krawczyk     2017-08-21  1277  
c4d06d2d208a6c Aviad Krawczyk     2017-08-21  1278  	hinic_hwdev_cb_register(nic_dev->hwdev, HINIC_MGMT_MSG_CMD_LINK_STATUS,
c4d06d2d208a6c Aviad Krawczyk     2017-08-21  1279  				nic_dev, link_status_event_handler);
c15850c709eb5c Luo bin            2020-07-25  1280  	hinic_hwdev_cb_register(nic_dev->hwdev,
c15850c709eb5c Luo bin            2020-07-25  1281  				HINIC_MGMT_MSG_CMD_CABLE_PLUG_EVENT,
c15850c709eb5c Luo bin            2020-07-25  1282  				nic_dev, cable_plug_event);
c15850c709eb5c Luo bin            2020-07-25  1283  	hinic_hwdev_cb_register(nic_dev->hwdev,
c15850c709eb5c Luo bin            2020-07-25  1284  				HINIC_MGMT_MSG_CMD_LINK_ERR_EVENT,
c15850c709eb5c Luo bin            2020-07-25  1285  				nic_dev, link_err_event);
c4d06d2d208a6c Aviad Krawczyk     2017-08-21  1286  
cc18a7543d2f63 Zhao Chen          2018-10-18  1287  	err = set_features(nic_dev, 0, nic_dev->netdev->features, true);
cc18a7543d2f63 Zhao Chen          2018-10-18  1288  	if (err)
cc18a7543d2f63 Zhao Chen          2018-10-18  1289  		goto err_set_features;
cc18a7543d2f63 Zhao Chen          2018-10-18  1290  
ea256222a46385 Luo bin            2020-06-28  1291  	/* enable pause and disable pfc by default */
ea256222a46385 Luo bin            2020-06-28  1292  	err = hinic_dcb_set_pfc(nic_dev->hwdev, 0, 0);
ea256222a46385 Luo bin            2020-06-28  1293  	if (err)
ea256222a46385 Luo bin            2020-06-28  1294  		goto err_set_pfc;
ea256222a46385 Luo bin            2020-06-28  1295  
7856e861627309 dann frazier       2018-07-23  1296  	SET_NETDEV_DEV(netdev, &pdev->dev);
cc18a7543d2f63 Zhao Chen          2018-10-18  1297  
a0337c0dee686a Luo bin            2020-06-28  1298  	err = hinic_init_intr_coalesce(nic_dev);
a0337c0dee686a Luo bin            2020-06-28  1299  	if (err) {
a0337c0dee686a Luo bin            2020-06-28  1300  		dev_err(&pdev->dev, "Failed to init_intr_coalesce\n");
a0337c0dee686a Luo bin            2020-06-28  1301  		goto err_init_intr;
a0337c0dee686a Luo bin            2020-06-28  1302  	}
a0337c0dee686a Luo bin            2020-06-28  1303  
253ac3a97921b8 Luo bin            2020-08-28  1304  	hinic_dbg_init(nic_dev);
253ac3a97921b8 Luo bin            2020-08-28  1305  
5215e16244ee58 Luo bin            2020-08-28  1306  	hinic_func_tbl_dbgfs_init(nic_dev);
5215e16244ee58 Luo bin            2020-08-28  1307  
5215e16244ee58 Luo bin            2020-08-28  1308  	err = hinic_func_table_debug_add(nic_dev);
5215e16244ee58 Luo bin            2020-08-28  1309  	if (err) {
5215e16244ee58 Luo bin            2020-08-28  1310  		dev_err(&pdev->dev, "Failed to add func_table debug\n");
5215e16244ee58 Luo bin            2020-08-28  1311  		goto err_add_func_table_dbg;
5215e16244ee58 Luo bin            2020-08-28  1312  	}
5215e16244ee58 Luo bin            2020-08-28  1313  
51ba902a16e68b Aviad Krawczyk     2017-08-21  1314  	err = register_netdev(netdev);
51ba902a16e68b Aviad Krawczyk     2017-08-21  1315  	if (err) {
51ba902a16e68b Aviad Krawczyk     2017-08-21  1316  		dev_err(&pdev->dev, "Failed to register netdev\n");
51ba902a16e68b Aviad Krawczyk     2017-08-21  1317  		goto err_reg_netdev;
51ba902a16e68b Aviad Krawczyk     2017-08-21  1318  	}
51ba902a16e68b Aviad Krawczyk     2017-08-21  1319  
51ba902a16e68b Aviad Krawczyk     2017-08-21  1320  	return 0;
51ba902a16e68b Aviad Krawczyk     2017-08-21  1321  
51ba902a16e68b Aviad Krawczyk     2017-08-21  1322  err_reg_netdev:
5215e16244ee58 Luo bin            2020-08-28  1323  	hinic_func_table_debug_rem(nic_dev);
5215e16244ee58 Luo bin            2020-08-28  1324  err_add_func_table_dbg:
5215e16244ee58 Luo bin            2020-08-28  1325  	hinic_func_tbl_dbgfs_uninit(nic_dev);
253ac3a97921b8 Luo bin            2020-08-28  1326  	hinic_dbg_uninit(nic_dev);
a0337c0dee686a Luo bin            2020-06-28  1327  	hinic_free_intr_coalesce(nic_dev);
a0337c0dee686a Luo bin            2020-06-28  1328  err_init_intr:
ea256222a46385 Luo bin            2020-06-28  1329  err_set_pfc:
cc18a7543d2f63 Zhao Chen          2018-10-18  1330  err_set_features:
c15850c709eb5c Luo bin            2020-07-25  1331  	hinic_hwdev_cb_unregister(nic_dev->hwdev,
c15850c709eb5c Luo bin            2020-07-25  1332  				  HINIC_MGMT_MSG_CMD_LINK_ERR_EVENT);
c15850c709eb5c Luo bin            2020-07-25  1333  	hinic_hwdev_cb_unregister(nic_dev->hwdev,
c15850c709eb5c Luo bin            2020-07-25  1334  				  HINIC_MGMT_MSG_CMD_CABLE_PLUG_EVENT);
c4d06d2d208a6c Aviad Krawczyk     2017-08-21  1335  	hinic_hwdev_cb_unregister(nic_dev->hwdev,
c4d06d2d208a6c Aviad Krawczyk     2017-08-21  1336  				  HINIC_MGMT_MSG_CMD_LINK_STATUS);
c4d06d2d208a6c Aviad Krawczyk     2017-08-21  1337  	cancel_work_sync(&rx_mode_work->work);
c4d06d2d208a6c Aviad Krawczyk     2017-08-21  1338  
25a3ba61060937 Aviad Krawczyk     2017-08-21  1339  err_set_mtu:
5e126e7c4e5275 Luo bin            2020-07-15  1340  	hinic_port_del_mac(nic_dev, netdev->dev_addr, 0);
25a3ba61060937 Aviad Krawczyk     2017-08-21  1341  err_add_mac:
5e126e7c4e5275 Luo bin            2020-07-15  1342  err_get_mac:
51ba902a16e68b Aviad Krawczyk     2017-08-21  1343  	pci_set_drvdata(pdev, NULL);
c4d06d2d208a6c Aviad Krawczyk     2017-08-21  1344  	destroy_workqueue(nic_dev->workq);
c4d06d2d208a6c Aviad Krawczyk     2017-08-21  1345  err_workq:
25a3ba61060937 Aviad Krawczyk     2017-08-21  1346  err_vlan_bitmap:
51ba902a16e68b Aviad Krawczyk     2017-08-21  1347  	free_netdev(netdev);
51ba902a16e68b Aviad Krawczyk     2017-08-21  1348  
51ba902a16e68b Aviad Krawczyk     2017-08-21  1349  err_alloc_etherdev:
51ba902a16e68b Aviad Krawczyk     2017-08-21  1350  err_num_qps:
51ba902a16e68b Aviad Krawczyk     2017-08-21  1351  	hinic_free_hwdev(hwdev);
c15850c709eb5c Luo bin            2020-07-25  1352  	hinic_devlink_free(devlink);
51ba902a16e68b Aviad Krawczyk     2017-08-21  1353  	return err;
51ba902a16e68b Aviad Krawczyk     2017-08-21  1354  }
51ba902a16e68b Aviad Krawczyk     2017-08-21  1355  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
