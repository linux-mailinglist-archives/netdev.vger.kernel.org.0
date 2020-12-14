Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C8D2D97AC
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 12:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438568AbgLNLts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 06:49:48 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:59248 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405918AbgLNLts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 06:49:48 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEBi1vg154508;
        Mon, 14 Dec 2020 11:48:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=V+Mtmc/dxJNvv1aQpXV+lTe9PulaOd5ociZlKtA1G1U=;
 b=iHHCbfk4PMzDIECX+bmLAPTbnabOQJRub8QG3TZj6zYJj6DrMozK0nRYdkZZpiyWMEBv
 fbyRIOCCikB1upcbIBpUvTE6n4LlQC9aHWbT3DBfI1VisYY8DadydoTqAXZYXnPbCUtE
 +Lnq6Vu8k6QvEleDX6gitNkl73oR+05FtEOeTDmPnPOdhuMz+BadKChez7FBgx9TAnPn
 DJ9U0G04BmF05PrRqc2mSRH/Lv+zDPqVbo23VpLEsyC3BAtJzIvprkT5z2lzzJUvurWZ
 IPr0e4r8dFIqHsSFQmUEiOjIXtXe2pSjB2IE6x6F4tBnn2C2nPNJrU7icWDG/DnPi1MI iQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 35ckcb4w40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 14 Dec 2020 11:48:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEBe2BK171801;
        Mon, 14 Dec 2020 11:48:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 35d7sucy82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Dec 2020 11:48:50 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BEBml0F009414;
        Mon, 14 Dec 2020 11:48:47 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Dec 2020 03:48:46 -0800
Date:   Mon, 14 Dec 2020 14:48:31 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     UNGLinuxDriver@microchip.com, vladimir.oltean@nxp.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: mscc: ocelot: Fix a resource leak in the error
 handling path of the probe function
Message-ID: <20201214114831.GE2809@kadam>
References: <20201213114838.126922-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201213114838.126922-1-christophe.jaillet@wanadoo.fr>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140083
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1011
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140083
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 13, 2020 at 12:48:38PM +0100, Christophe JAILLET wrote:
> In case of error after calling 'ocelot_init()', it must be undone by a
> corresponding 'ocelot_deinit()' call, as already done in the remove
> function.
> 

This changes the behavior slightly in another way as well, but it's
probably a bug fix.

drivers/net/ethernet/mscc/ocelot_vsc7514.c
  1250          ports = of_get_child_by_name(np, "ethernet-ports");
  1251          if (!ports) {
  1252                  dev_err(ocelot->dev, "no ethernet-ports child node found\n");
  1253                  return -ENODEV;
  1254          }
  1255  
  1256          ocelot->num_phys_ports = of_get_child_count(ports);
  1257          ocelot->num_flooding_pgids = 1;
  1258  
  1259          ocelot->vcap = vsc7514_vcap_props;
  1260          ocelot->inj_prefix = OCELOT_TAG_PREFIX_NONE;
  1261          ocelot->xtr_prefix = OCELOT_TAG_PREFIX_NONE;
  1262          ocelot->npi = -1;
  1263  
  1264          err = ocelot_init(ocelot);
  1265          if (err)
  1266                  goto out_put_ports;
  1267  
  1268          err = mscc_ocelot_init_ports(pdev, ports);
  1269          if (err)
  1270                  goto out_put_ports;
  1271  
  1272          if (ocelot->ptp) {
  1273                  err = ocelot_init_timestamp(ocelot, &ocelot_ptp_clock_info);
  1274                  if (err) {
  1275                          dev_err(ocelot->dev,
  1276                                  "Timestamp initialization failed\n");
  1277                          ocelot->ptp = 0;
  1278                  }

In the original code, if ocelot_init_timestamp() failed we returned
a negative error code but now we return success.  This probably is what
the original authors intended, though.

  1279          }
  1280  
  1281          register_netdevice_notifier(&ocelot_netdevice_nb);
  1282          register_switchdev_notifier(&ocelot_switchdev_nb);
  1283          register_switchdev_blocking_notifier(&ocelot_switchdev_blocking_nb);
  1284  
  1285          dev_info(&pdev->dev, "Ocelot switch probed\n");
  1286  
  1287  out_put_ports:
  1288          of_node_put(ports);
  1289          return err;
  1290  }

regards,
dan carpenter

