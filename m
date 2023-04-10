Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2669E6DC5B1
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 12:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjDJKW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 06:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDJKWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 06:22:54 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2108.outbound.protection.outlook.com [40.107.92.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7763030E7;
        Mon, 10 Apr 2023 03:22:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hKTxMisFYuc1Y5WBORFHUJbSMFqV2QD6APt4iOudhs+3J7peJP3LdRvisWBow/ZTuTfBn+tG5fh/bC3xBAM4xvu2xwtHIxFjHzPY2rg9+JB78uJzRtjXZnP7g75fCtEOJ5UhGBTapp3qwZyrc+GDNz/Bu71vmsLWpZEZSlzgnZZePOt7eSg1jrcqp9kv+Klqo2CxjnvknSo8QvPZnqx1/O9Z5LltPlbmlIjLUF4pYljDLKmEeJ2Sp1hdxcgaAM/o4Lu1VJkeGINdrPTSGMkyDIDEGbMlPlxJj1NW9GB2JbR00unpzfVMNnrtWbQK1dOMRna8E1B/QA42YiVwcIPJ4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+pDKZkvAfcpMhcqQk/6ASFLimjbmq3sXbZzxpO4yRSg=;
 b=I2udLeHPVHh29rg+LFHg2aac5U6dO0bY7MgGcYmbaLNE6N2ul4Mo9AwBk1V5wvsn4ZmVfeva6Ab4EU9vQWRM2urOKh3G+EniZlico7hkXI2v8Ny7p7GPFusY+cQ0tnOJxEnivAaotQvGuY9AJMV4LZmj5vjmr+bT9hqKKqWxqs4uh8Koa+DpOz2YWnPVFZ5Ida5Lz585gd1UNcnGUTvi0ElsR0NMTRYBAjzCFa5bgtLN4ypnI0tSpu+xWVtqzoRWLG6FlstGyRfaTMNueRrFg57Qd7Gte8e+TSEpcXuSSzzRIwR1tlsuEeRS0pog2j53aY43UpzQmakK2XNk8yS7Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+pDKZkvAfcpMhcqQk/6ASFLimjbmq3sXbZzxpO4yRSg=;
 b=EkapUdYzG/i4ypqlTyco2Od0tr66uBR7B1Z+5ssDLmPJQCzqsexufw7E0SIkBgoK0VEl9a+6wsXVjHzIgm6fhUA3szLt960V9H6QiBWHceS/vH07w7yiRYpxBqkaW96Gv4l0O+rwDqQdWTeZdUaExX44aHTndfcYXnLQCGTek6I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO6PR13MB5369.namprd13.prod.outlook.com (2603:10b6:303:14e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Mon, 10 Apr
 2023 10:22:49 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.038; Mon, 10 Apr 2023
 10:22:49 +0000
Date:   Mon, 10 Apr 2023 12:22:42 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Gautam Dawar <gautam.dawar@amd.com>
Cc:     linux-net-drivers@amd.com, jasowang@redhat.com,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com
Subject: Re: [PATCH net-next v4 06/14] sfc: implement vDPA management device
 operations
Message-ID: <ZDPjcpBQBPqmZKh1@corigine.com>
References: <20230407081021.30952-1-gautam.dawar@amd.com>
 <20230407081021.30952-7-gautam.dawar@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407081021.30952-7-gautam.dawar@amd.com>
X-ClientProxiedBy: AS4P191CA0019.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d9::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO6PR13MB5369:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a5333a6-b756-44f2-2e4c-08db39ad88cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ULWUCstPekcY3vyhlcnR75ZV6Kp95+KJnbV5SWPpdaPbFefHzdC7squPE+HvRzuwn3RTCFTUKnh+/Fh9n+BDDZ2ZmdWQYY6ShZ3Dqaw5VAkRaJW0/3y28n6bUDSblHDmsKZ2PWPDb6M0BMtkuRlS/2B+fxcCCW5fJTf8F75a3Po+YcS8p9w1b8ZEruKm2Vxl9u+9KPYPNeil5R3c1TIHltPa99aavSR5hn8KJFPwxSF45rWRJP4x56H6g3CS5Qh+aoTwbqJJRgQTbmgjcqyfXRCNu4b/UEWYlglhqUzJeZFu/Hf/gMgkTYEo+agVToo6pVIdONp33PGxR8lOKgtnHJjRpHRlVeqWv1E93+BFn/rqqlyBOy4M1rBfVLqrtvOGI65SYRquVIMlRc4yBUdpN63UFEt1SEIK+S1HOH9sKjiKyp+umoMdSBJLSjwG6IWChf1YUrKXXvPcjoyaSbbQqHSYHXm5CsJU7+Wbc7d5DBTEoGvgUZDgD7EJPzmyqGhLse7eRZuemEB2ifaZWaBbXnBrhdBz1NEl4hvyP2pHS0UXlnMPsP0ymDgvtCO2LYrRDmERNNxLQAwLk9GCHhlXrGnajgt5WT2BQ00QetsxZQU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(136003)(39840400004)(366004)(376002)(451199021)(478600001)(6666004)(38100700002)(8676002)(8936002)(316002)(41300700001)(4326008)(66556008)(66476007)(6916009)(66946007)(54906003)(186003)(36756003)(2906002)(6506007)(6512007)(86362001)(83380400001)(2616005)(5660300002)(7416002)(6486002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lVr6R1nFD6C3pmA+c7c2bP0cyc7XaA7miYXzc5VZxbFrL0hNGFy1fIkCDt/5?=
 =?us-ascii?Q?4lbtZXf4qCEFLwNTYTHxnskZGscJsnvBxhNbXj4+IEjV9pMARJ+/4cswQqlr?=
 =?us-ascii?Q?+yyfTTK6zhpwNZcJ2x4JqMdpdHij71lK6GFC+NyFn9rux3RRvVGiGQ/BDdto?=
 =?us-ascii?Q?NAVhgmPmsOxQ7tBZROpGlq2EalNwXDOZYfz0cilksr3ckN8BnJhl9wyjiHOV?=
 =?us-ascii?Q?yGWBmIuWNhaQrBg6H+RxHnvDLJejoKrwnPKmguz63cX9pGFnPUfPPh7ULprR?=
 =?us-ascii?Q?LFg9PcPlOvmYV2L4vm8ppFUMshZMp9ZCu27YgfrhcRSjEQf2SEkyab/Gd3xW?=
 =?us-ascii?Q?Uv5Uw24VYAqyL9YKtlptBGzNXPYHuaAPargcpj+UqmaE7QLh1jhxqEo9pQvi?=
 =?us-ascii?Q?9kyQ6l3i60aB3mO7216xbnS0VkBerBccChoZHFw7C3U64pKuUidhnje+J73f?=
 =?us-ascii?Q?k3buTVnDLCWgoHMOaBVtntvhHo5iu1qZnlLWvIT2ewHHgyQ8IJdw8sefqIcm?=
 =?us-ascii?Q?hbMUoXsEH0d5jeAKAfDaBvapfNigFAVJUlQe30swdbAJaIov8c1MDCSpCWbe?=
 =?us-ascii?Q?oDZFe3OyL1YhH9fZO38L1lWNuJrmCPx44BnRZVnN+GcJwl9ou57r3CRwaZDf?=
 =?us-ascii?Q?fEx7Spyyp/gQT7+bTPm2s50vysKnsLucgFnxWrz/nGgHtifTO1tYvDmvbxLw?=
 =?us-ascii?Q?LnKo+Y/JsPu6TJwbhFutLuWQPc+R/Bev40TvkXjxMXlXzSrzZZGa/ASAAWzd?=
 =?us-ascii?Q?A4H1L/d7TacbhQWUQoBClsWZGSowVlBIuXOBbhcOnf7MUCAMHKw+oDSjMp6W?=
 =?us-ascii?Q?eMaLDq+hRsYC3e2rjEkqjhjIlzAG5EO9oflR8lwX22B0aKjna3YukMlHdrA1?=
 =?us-ascii?Q?xer0QuZak/HdI6ulx7YGzG8FF6S/QNpN/O4vAoOXDdBi5pdNi/QvoKCvGlKc?=
 =?us-ascii?Q?cW1Vfo1R5VQmwa1fn2mTZXE0Hvw2JVhpRVwnhNzNf6faebRW86Hzev7zGIfE?=
 =?us-ascii?Q?aEPIy22hmSkADKbXCY5aLHCAMsQurpimFshBKNZFzJu/uVJiJt1ETqHk6LD/?=
 =?us-ascii?Q?mQ7R02TRbDNQkXELBef+0/1tkBu3eMrvnu0eEP3MT2oMZFNy+Tnn5nhBh8U/?=
 =?us-ascii?Q?drZUyYwHg05ga/iBf7LCdfKjBi6zPJ0OlZEYuqlELZNBkqaSPf8CwA2RF9dl?=
 =?us-ascii?Q?caj7Cg3rkoSaxDlValvRGzRT49aRs9VwbI0vIH6xmcThGZ5AjsJbNRct29Bx?=
 =?us-ascii?Q?oCI6fXMHWNX8B5c4mKhPB6Ur4DYZqi4WqnRNapilE9hSnuGka07xmZQipGhK?=
 =?us-ascii?Q?BeQqTtKJBkpN15Ed+wp7jtJWnIx/f6knXMXM9tsiB2/6lKvl1UorZEbB3j/j?=
 =?us-ascii?Q?Bh3RhDOQOK4nAUz0BiLTVCMyiaUvYqRFFS7VEJMx4E2XOZi0svHItLXdfyJI?=
 =?us-ascii?Q?U2kxMGzEXyo7OBIp7CeMYUSL3SVPZ8Uc3K26bHG0xTsAFtQT8lpy/tLepWLe?=
 =?us-ascii?Q?H5iB7MUl7zKSsZHmcnkUGLL3TBJVHIz5uswgJPx3mtK2Pkaz5LW4IbRF/Mu0?=
 =?us-ascii?Q?wTauSUu60oDAYVslBzqIDe8U3dUmrAfw4wu6deC40Eut27cVfKG9hmb8a0P1?=
 =?us-ascii?Q?e233rhwl05Uz8A3WPoSwoSnclugoR58mj1SPhkixTqQucYHxFr2K3EW789kW?=
 =?us-ascii?Q?1FPL+w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a5333a6-b756-44f2-2e4c-08db39ad88cc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 10:22:49.2182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /DbnkD12bpSGKWo1y/cImXJa3l8XVmnvoMNCReg+U6PmXn081q6Y5IjgDMEIVnEuvi61hc996WGFX99NL49fthj1hvooVrPGXv7vCpFNMcg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR13MB5369
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 01:40:07PM +0530, Gautam Dawar wrote:
> To allow vDPA device creation and deletion, add a vDPA management
> device per function. Currently, the vDPA devices can be created
> only on a VF. Also, for now only network class of vDPA devices
> are supported.
> 
> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>

Hi Gautam,

some minor feedback from my side is inline.

> diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c

...

> @@ -1286,13 +1286,35 @@ int ef100_probe_netdev_pf(struct efx_nic *efx)
>  
>  int ef100_probe_vf(struct efx_nic *efx)
>  {
> -	return ef100_probe_main(efx);
> +	struct ef100_nic_data *nic_data __maybe_unused;
> +	int rc;
> +
> +	rc = ef100_probe_main(efx);
> +	if (rc)
> +		return rc;
> +
> +#ifdef CONFIG_SFC_VDPA
> +	nic_data = efx->nic_data;
> +	if (nic_data->vdpa_supported) {
> +		rc = ef100_vdpa_register_mgmtdev(efx);
> +		if (rc)
> +			pci_warn(efx->pci_dev,
> +				 "register_mgmtdev failed, rc: %d\n", rc);
> +	}
> +#endif

I think it would be nicer to factor the #ifdef coded out, perhaps into a
helper like this (completely untested!).

void ef100_probe_vf_vdpa(struct efx_nic *efx)
{
#ifdef CONFIG_SFC_VDPA
	struct ef100_nic_data *nic_data = efx->nic_data;

	nic_data = efx->nic_data;
	if (nic_data->vdpa_supported) {
		int rc = ef100_vdpa_register_mgmtdev(efx);
		if (rc)
			pci_warn(efx->pci_dev,
				 "register_mgmtdev failed, rc: %d\n", rc);
	}
#endif
}

Or perhaps an approach similar to the one you have taken,
but using IS_ENABLED() rather than #ifdef

> +
> +	return 0;
>  }
>  
>  void ef100_remove(struct efx_nic *efx)
>  {
>  	struct ef100_nic_data *nic_data = efx->nic_data;
>  
> +#ifdef CONFIG_SFC_VDPA
> +	if (nic_data->vdpa_supported)

nic_data is dereferenced here.
But a bit futher down this function there is a check for nic_data being NULL.

Reported by Smatch as:

drivers/net/ethernet/sfc/ef100_nic.c:1325 ef100_remove() warn: variable dereferenced before check 'nic_data' (see line 1314)

> +		ef100_vdpa_unregister_mgmtdev(efx);
> +#endif

Again, I think it would be nice to factor this #ifdef out somehow.

> +
>  	if (IS_ENABLED(CONFIG_SFC_SRIOV) && efx->mae) {
>  		efx_ef100_fini_reps(efx);
>  		efx_fini_mae(efx);
> diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
> index a01e9d643ccd..e63ea555116c 100644
> --- a/drivers/net/ethernet/sfc/ef100_nic.h
> +++ b/drivers/net/ethernet/sfc/ef100_nic.h
> @@ -69,6 +69,13 @@ enum ef100_bar_config {
>  	EF100_BAR_CONFIG_VDPA,
>  };
>  
> +#ifdef CONFIG_SFC_VDPA
> +enum ef100_vdpa_class {
> +	EF100_VDPA_CLASS_NONE,
> +	EF100_VDPA_CLASS_NET,
> +};
> +#endif
> +

I don't think there is any need to guard this with an #ifdef

>  struct ef100_nic_data {
>  	struct efx_nic *efx;
>  	struct efx_buffer mcdi_buf;
> @@ -76,9 +83,11 @@ struct ef100_nic_data {
>  	u32 datapath_caps2;
>  	u32 datapath_caps3;
>  	unsigned int pf_index;
> +	unsigned int vf_index;
>  	u16 warm_boot_count;
>  #ifdef CONFIG_SFC_VDPA
>  	bool vdpa_supported; /* true if vdpa is supported on this PCIe FN */
> +	enum ef100_vdpa_class vdpa_class;
>  #endif
>  	u8 port_id[ETH_ALEN];
>  	DECLARE_BITMAP(evq_phases, EFX_MAX_CHANNELS);

...

> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h

...

> +static inline bool efx_vdpa_is_little_endian(struct ef100_vdpa_nic *vdpa_nic)
> +{
> +	return virtio_legacy_is_little_endian() ||
> +		(vdpa_nic->features & (1ULL << VIRTIO_F_VERSION_1));
> +}

Using BIT_ULL seems appropriate here.

...

> diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
> index 3dc9eae5a81d..1da71deac71c 100644
> --- a/drivers/net/ethernet/sfc/net_driver.h
> +++ b/drivers/net/ethernet/sfc/net_driver.h
> @@ -1090,6 +1090,12 @@ struct efx_nic {
>  	int rx_packet_len_offset;
>  	int rx_packet_ts_offset;
>  	bool rx_scatter;
> +#ifdef CONFIG_SFC_VDPA
> +	/** @mgmt_dev: vDPA Management device */
> +	struct vdpa_mgmt_dev *mgmt_dev;
> +	/** @vdpa_nic: vDPA device structure (EF100) */
> +	struct ef100_vdpa_nic *vdpa_nic;
> +#endif

I think the commends belong in the kdoc immediately above the structure
definition. Or is this the way it is done for conditionally present
fields (I don't know) ?

>  	struct efx_rss_context rss_context;
>  	struct mutex rss_lock;
>  	u32 vport_id;
> -- 
> 2.30.1
> 
